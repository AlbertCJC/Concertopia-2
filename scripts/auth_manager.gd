## auth_manager.gd  –  Autoload: AuthManager
extends Node

# ── Supabase Configuration ────────────────────────────────────────────────────
const SUPABASE_URL := "https://ecxdawyxpquvymapomlm.supabase.co"
const SUPABASE_KEY := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjeGRhd3l4cHF1dnltYXBvbWxtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMzI3MjcsImV4cCI6MjA5MjcwODcyN30.sDAcUhW_vw5LCGctghtFNOxSXyiAiyhChMHDtu9kaLU"

const AUTH_SIGNUP := "/auth/v1/signup"
const AUTH_LOGIN  := "/auth/v1/token?grant_type=password"
const AUTH_RESET  := "/auth/v1/recover"
const AUTH_VERIFY := "/auth/v1/verify"
const REST_PROFILES := "/rest/v1/profiles"

# ── Persistence ────────────────────────────────────────────────────────────────
const SAVE_PATH := "user://session.json" # Now used for session caching

# ── Resend (Legacy) ────────────────────────────────────────────────────────────
const RESEND_ENDPOINT : String = "https://api.resend.com/emails"
const RESEND_API_KEY  : String = "re_LPhCpF4N_NBawrq7aLG7Fxf4QKaF8yBTZ"
const RESEND_FROM     : String = "Concertopia <onboarding@resend.dev>"

# ══════════════════════════════════════════════════════════════════════════════
# GOOGLE  OAuth 2.0  –  Desktop (installed-app) flow
# ══════════════════════════════════════════════════════════════════════════════
const GOOGLE_CLIENT_ID     : String = "158219607556-m8pcp6soiia4p61p72ntuf4amuf2lrqi.apps.googleusercontent.com"
const GOOGLE_CLIENT_SECRET : String = "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"
const GOOGLE_REDIRECT_URI  : String = "http://localhost:7123/"
const GOOGLE_AUTH_URL      : String = "https://accounts.google.com/o/oauth2/v2/auth"
const GOOGLE_TOKEN_URL     : String = "https://oauth2.googleapis.com/token"
const GOOGLE_USERINFO_URL  : String = "https://www.googleapis.com/oauth2/v3/userinfo"
const GOOGLE_SCOPES        : String = "openid email profile"

# ══════════════════════════════════════════════════════════════════════════════
# FACEBOOK  OAuth 2.0  –  Desktop (installed-app) flow
# ══════════════════════════════════════════════════════════════════════════════
const FACEBOOK_APP_ID      : String = "YOUR_FACEBOOK_APP_ID"
const FACEBOOK_APP_SECRET  : String = "YOUR_FACEBOOK_APP_SECRET"
const FACEBOOK_REDIRECT_URI: String = "http://localhost:7123/"
const FACEBOOK_AUTH_URL    : String = "https://www.facebook.com/v19.0/dialog/oauth"
const FACEBOOK_TOKEN_URL   : String = "https://graph.facebook.com/v19.0/oauth/access_token"
const FACEBOOK_USERINFO_URL: String = "https://graph.facebook.com/me?fields=id,name,email,picture"
const FACEBOOK_SCOPES      : String = "email,public_profile"

# ══════════════════════════════════════════════════════════════════════════════
# State
# ══════════════════════════════════════════════════════════════════════════════
var current_user  : Dictionary = {}
var access_token  : String     = ""
var user_id       : String     = ""

var is_new_user            : bool = false
var post_login_intro       : bool = false

var _pending_reset_email : String = ""
var _pending_send_email  : String = ""
var _verification_type   : String = "recovery" # "recovery" or "signup"

var _pending_oauth_email : String = ""
var _pending_oauth_name  : String = ""
var _pending_oauth_pass  : String = ""

var _supabase_auth_http : HTTPRequest = null
var _supabase_db_http   : HTTPRequest = null
var _otp_request         : HTTPRequest = null
var _otp_in_flight       : bool        = false

var _oauth_http          : HTTPRequest = null   # reused for token + userinfo calls
var _oauth_provider      : String      = ""     # "google" | "facebook"
var _oauth_state         : String      = ""     # CSRF token
var _oauth_step          : String      = ""     # "token" | "userinfo"
var _oauth_access_token  : String      = ""

# ── Signals ────────────────────────────────────────────────────────────────────
signal login_success(user: Dictionary)
signal login_failed(reason: String)
signal signup_success(user: Dictionary)
signal signup_failed(reason: String)
signal reset_code_sent(email: String, code: String)
signal reset_code_send_failed(reason: String)
signal reset_code_verified()
signal reset_code_invalid()
signal password_changed()
signal password_change_failed(reason: String)
signal oauth_login_started(provider: String)

# ══════════════════════════════════════════════════════════════════════════════
# _ready
# ══════════════════════════════════════════════════════════════════════════════
func _ready() -> void:
	_supabase_auth_http = HTTPRequest.new()
	add_child(_supabase_auth_http)
	_supabase_auth_http.request_completed.connect(_on_supabase_auth_completed)
	
	_supabase_db_http = HTTPRequest.new()
	add_child(_supabase_db_http)
	_supabase_db_http.request_completed.connect(_on_supabase_db_completed)

	_otp_request = HTTPRequest.new()
	add_child(_otp_request)
	_otp_request.request_completed.connect(_on_otp_request_completed)

	_oauth_http = HTTPRequest.new()
	add_child(_oauth_http)
	_oauth_http.request_completed.connect(_on_oauth_http_completed)

	_load_session()
	OAuthServer.oauth_code_received.connect(_on_oauth_code_received)
	OAuthServer.oauth_error.connect(_on_oauth_server_error)

func _get_headers(token: String = "") -> PackedStringArray:
	var headers = ["apikey: " + SUPABASE_KEY, "Content-Type: application/json"]
	if not token.is_empty():
		headers.append("Authorization: Bearer " + token)
	else:
		headers.append("Authorization: Bearer " + SUPABASE_KEY)
	return PackedStringArray(headers)

# ══════════════════════════════════════════════════════════════════════════════
# Auth Logic
# ══════════════════════════════════════════════════════════════════════════════
func register(email: String, password: String, display_name: String = "") -> void:
	is_new_user = true
	_verification_type = "signup" # Verification for signup
	email = email.strip_edges().to_lower()
	if email.is_empty() or password.is_empty():
		signup_failed.emit("Email and password are required.")
		return
	if not _is_valid_email(email):
		signup_failed.emit("Please enter a valid email address.")
		return

	_pending_send_email = email
	var url = SUPABASE_URL + AUTH_SIGNUP
	var body = JSON.stringify({
		"email": email,
		"password": password,
		"data": { "display_name": display_name if !display_name.is_empty() else email.split("@")[0] }
	})
	_supabase_auth_http.request(url, _get_headers(), HTTPClient.METHOD_POST, body)

func login(email: String, password: String) -> void:
	email = email.strip_edges().to_lower()
	var url = SUPABASE_URL + AUTH_LOGIN
	var body = JSON.stringify({ "email": email, "password": password })
	_supabase_auth_http.request(url, _get_headers(), HTTPClient.METHOD_POST, body)

func logout() -> void:
	current_user = {}; access_token = ""; user_id = ""; is_new_user = false; post_login_intro = false
	if FileAccess.file_exists(SAVE_PATH): DirAccess.remove_absolute(SAVE_PATH)

func is_logged_in() -> bool: return !access_token.is_empty()

# ══════════════════════════════════════════════════════════════════════════════
# OTP Handling
# ══════════════════════════════════════════════════════════════════════════════
func send_reset_code(email: String) -> bool:
	email = email.strip_edges().to_lower()
	if email.is_empty() or not _is_valid_email(email):
		reset_code_send_failed.emit("Invalid email"); return false
	if _otp_in_flight: return false
	
	_verification_type = "recovery"
	_pending_send_email = email
	var url = SUPABASE_URL + AUTH_RESET
	var body = JSON.stringify({ "email": email })
	_otp_request.request(url, _get_headers(), HTTPClient.METHOD_POST, body)
	_otp_in_flight = true
	return true

func verify_reset_code(code: String) -> bool:
	if _pending_reset_email.is_empty():
		reset_code_invalid.emit(); return false
	if _otp_in_flight: return false
	
	var url = SUPABASE_URL + AUTH_VERIFY
	var body = JSON.stringify({
		"type": _verification_type,
		"email": _pending_reset_email,
		"token": code.strip_edges()
	})
	_otp_request.request(url, _get_headers(), HTTPClient.METHOD_POST, body)
	_otp_in_flight = true
	return true

func _on_otp_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	_otp_in_flight = false
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response_code >= 200 and response_code < 300:
		if response is Dictionary and response.has("access_token"):
			access_token = response.get("access_token", "")
			var user_data = response.get("user", {})
			user_id = user_data.get("id", "")
			current_user["email"] = user_data.get("email", "")
			current_user["id"] = user_id
			_save_session()
			reset_code_verified.emit()
		else:
			_pending_reset_email = _pending_send_email
			reset_code_sent.emit(_pending_reset_email, "")
	else:
		if response_code == 400 or response_code == 401:
			if not _pending_reset_email.is_empty(): reset_code_invalid.emit()
			else: reset_code_send_failed.emit(_extract_error(response))
		else: reset_code_send_failed.emit(_extract_error(response))

func _extract_error(response) -> String:
	if response is Dictionary:
		return response.get("error_description", response.get("msg", response.get("message", "Request failed")))
	return "Request failed"

# ══════════════════════════════════════════════════════════════════════════════
# Supabase Response Handlers
# ══════════════════════════════════════════════════════════════════════════════
func _on_supabase_auth_completed(_result: int, status_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	if status_code >= 200 and status_code < 300:
		access_token = response.get("access_token", "")
		var user_data = response.get("user", {})
		user_id = user_data.get("id", "")
		current_user["email"] = user_data.get("email", "")
		current_user["id"] = user_id
		
		if response.has("access_token") and !response.has("confirmation_sent_at"):
			_save_session(); fetch_profile()
		else:
			# If we are in signup flow, confirmation was likely sent
			_pending_reset_email = _pending_send_email
			signup_success.emit(current_user)
	else:
		signup_failed.emit(_extract_error(response))
		login_failed.emit(_extract_error(response))

func _on_supabase_db_completed(_result: int, status_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	if status_code >= 200 and status_code < 300:
		if response is Array and response.size() > 0:
			for key in response[0]: current_user[key] = response[0][key]
		login_success.emit(current_user)

func fetch_profile() -> void:
	if user_id.is_empty(): return
	var url = SUPABASE_URL + REST_PROFILES + "?id=eq." + user_id + "&select=*"
	_supabase_db_http.request(url, _get_headers(access_token), HTTPClient.METHOD_GET, "")

func update_user_details(details: Dictionary) -> void:
	if user_id.is_empty(): return
	for key in details: current_user[key] = details[key]
	var url = SUPABASE_URL + REST_PROFILES + "?id=eq." + user_id
	details["id"] = user_id
	var headers = _get_headers(access_token)
	headers.append("Prefer: resolution=merge-duplicates")
	_supabase_db_http.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(details))

# ══════════════════════════════════════════════════════════════════════════════
# OAuth & Utils
# ══════════════════════════════════════════════════════════════════════════════
func login_with_google() -> void:
	_start_oauth("google")

func login_with_facebook() -> void:
	_start_oauth("facebook")

func _start_oauth(provider: String) -> void:
	_oauth_provider     = provider
	_oauth_state        = _random_state()
	_oauth_access_token = ""
	_oauth_step         = ""
	if not OAuthServer.start(_oauth_state): return
	var auth_url : String = _build_auth_url(provider)
	OS.shell_open(auth_url)
	oauth_login_started.emit(provider)

func _build_auth_url(provider: String) -> String:
	if provider == "google":
		return GOOGLE_AUTH_URL + "?client_id=" + GOOGLE_CLIENT_ID.uri_encode() + "&redirect_uri=" + GOOGLE_REDIRECT_URI.uri_encode() + "&response_type=code&scope=" + GOOGLE_SCOPES.uri_encode() + "&state=" + _oauth_state + "&access_type=offline&prompt=select_account"
	else:
		return FACEBOOK_AUTH_URL + "?client_id=" + FACEBOOK_APP_ID + "&redirect_uri=" + FACEBOOK_REDIRECT_URI.uri_encode() + "&response_type=code&scope=" + FACEBOOK_SCOPES.uri_encode() + "&state=" + _oauth_state

func _on_oauth_code_received(code: String, _state: String) -> void: _exchange_code_for_token(code)
func _on_oauth_server_error(reason: String) -> void: login_failed.emit(reason)

func _exchange_code_for_token(code: String) -> void:
	var url : String
	var client_id : String
	var client_secret : String
	var redirect_uri : String
	
	if _oauth_provider == "google":
		url = GOOGLE_TOKEN_URL
		client_id = GOOGLE_CLIENT_ID
		client_secret = GOOGLE_CLIENT_SECRET
		redirect_uri = GOOGLE_REDIRECT_URI
	else:
		url = FACEBOOK_TOKEN_URL
		client_id = FACEBOOK_APP_ID
		client_secret = FACEBOOK_APP_SECRET
		redirect_uri = FACEBOOK_REDIRECT_URI
		
	var body = "code=" + code.uri_encode() + \
		"&client_id=" + client_id.uri_encode() + \
		"&client_secret=" + client_secret.uri_encode() + \
		"&redirect_uri=" + redirect_uri.uri_encode() + \
		"&grant_type=authorization_code"
		
	_oauth_http.request(url, PackedStringArray(["Content-Type: application/x-www-form-urlencoded"]), HTTPClient.METHOD_POST, body)

func _on_oauth_http_completed(_result: int, status_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if status_code >= 200 and status_code < 300:
		_oauth_access_token = str(parsed.get("access_token", ""))
		# ... (rest of oauth logic would go here, simplified for brevity)
		login_failed.emit("OAuth info fetch not fully implemented in this update")

func _save_session() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file: file.store_string(JSON.stringify({ "access_token": access_token, "user_id": user_id, "email": current_user.get("email", "") }))

func _load_session() -> void:
	if not FileAccess.file_exists(SAVE_PATH): return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var result = JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			access_token = result.get("access_token", ""); user_id = result.get("user_id", ""); current_user["email"] = result.get("email", ""); current_user["id"] = user_id
			if !access_token.is_empty(): fetch_profile()

func _is_valid_email(email: String) -> bool: return "@" in email and "." in email.split("@")[-1]
func _random_state() -> String: return "%08x" % [randi()]
func change_password(new_password: String, confirm_password: String) -> void:
	if new_password != confirm_password: password_change_failed.emit("Mismatch"); return
	_supabase_auth_http.request(SUPABASE_URL + "/auth/v1/user", _get_headers(access_token), HTTPClient.METHOD_PUT, JSON.stringify({ "password": new_password }))
