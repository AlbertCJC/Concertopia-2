extends Node

const SAVE_PATH := "user://users.json"

# users dict: { email: { password, display_name } }
var _users: Dictionary = {}
var current_user: Dictionary = {}

# Stores the reset code sent to a user's email (simulated)
var _pending_reset_email: String = ""
var _pending_reset_code: String = ""

signal login_success(user: Dictionary)
signal login_failed(reason: String)
signal signup_success(user: Dictionary)
signal signup_failed(reason: String)
signal reset_code_sent(email: String, code: String)   # exposes code so UI can display it (simulate email)
signal reset_code_verified()
signal reset_code_invalid()
signal password_changed()
signal password_change_failed(reason: String)

func _ready() -> void:
	_load_users()

# ── Registration ──────────────────────────────────────────────────────────────

func register(email: String, password: String, display_name: String = "") -> bool:
	email = email.strip_edges().to_lower()
	if email.is_empty() or password.is_empty():
		signup_failed.emit("Email and password are required.")
		return false
	if not _is_valid_email(email):
		signup_failed.emit("Please enter a valid email address.")
		return false
	if password.length() < 6:
		signup_failed.emit("Password must be at least 6 characters.")
		return false
	if _users.has(email):
		signup_failed.emit("An account with that email already exists.")
		return false
	_users[email] = {
		"password": password,
		"display_name": display_name if display_name != "" else email.split("@")[0]
	}
	_save_users()
	current_user = { "email": email, "display_name": _users[email]["display_name"] }
	signup_success.emit(current_user)
	return true

# ── Login / Logout ────────────────────────────────────────────────────────────

func login(email: String, password: String) -> bool:
	email = email.strip_edges().to_lower()
	if email.is_empty() or password.is_empty():
		login_failed.emit("Please enter your email and password.")
		return false
	if not _users.has(email):
		login_failed.emit("No account found with that email.")
		return false
	if _users[email]["password"] != password:
		login_failed.emit("Incorrect password. Please try again.")
		return false
	current_user = { "email": email, "display_name": _users[email]["display_name"] }
	login_success.emit(current_user)
	return true

func logout() -> void:
	current_user = {}

func is_logged_in() -> bool:
	return current_user.size() > 0

# ── Forgot Password Flow ──────────────────────────────────────────────────────

func send_reset_code(email: String) -> bool:
	email = email.strip_edges().to_lower()
	if not _users.has(email):
		# Don't reveal whether email exists — silently succeed (security best practice)
		# But still emit so UI can navigate forward
		_pending_reset_email = email
		_pending_reset_code = _generate_code()
		reset_code_sent.emit(email, _pending_reset_code)
		return true
	_pending_reset_email = email
	_pending_reset_code = _generate_code()
	reset_code_sent.emit(email, _pending_reset_code)
	return true

func verify_reset_code(code: String) -> bool:
	if code.strip_edges() == _pending_reset_code:
		reset_code_verified.emit()
		return true
	else:
		reset_code_invalid.emit()
		return false

func change_password(new_password: String, confirm_password: String) -> bool:
	if new_password.length() < 6:
		password_change_failed.emit("Password must be at least 6 characters.")
		return false
	if new_password != confirm_password:
		password_change_failed.emit("Passwords do not match.")
		return false
	if _pending_reset_email.is_empty() or not _users.has(_pending_reset_email):
		password_change_failed.emit("Session expired. Please restart the reset process.")
		return false
	_users[_pending_reset_email]["password"] = new_password
	_save_users()
	_pending_reset_email = ""
	_pending_reset_code = ""
	password_changed.emit()
	return true

# ── Persistence ───────────────────────────────────────────────────────────────

func _save_users() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_users))
		file.close()

func _load_users() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var result = JSON.parse_string(text)
		if result is Dictionary:
			_users = result

# ── Helpers ───────────────────────────────────────────────────────────────────

func _is_valid_email(email: String) -> bool:
	return "@" in email and "." in email.split("@")[-1]

func _generate_code() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return "%04d" % rng.randi_range(1000, 9999)
