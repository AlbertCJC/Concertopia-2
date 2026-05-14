class_name Env

## ── BAKED SECRETS (Standalone / Secure Mode) ──────────────────────────────────
## Paste your keys here for a truly standalone EXE. 
## When these are filled, the app will ignore external .cfg files.
static var BAKED_SECRETS := {
	"supabase": {
		"url": "https://jkhclleriwdsrojzsekx.supabase.co",
		"key": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpraGNsbGVyaXdkc3JvanpzZWt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3ODYzNzQsImV4cCI6MjA5MzM2MjM3NH0.N4tQ6kgm-X7ThJoWYzpXI2EXRKVnwSlcVd7X1OFLJ30"
	},
	"google": {
		"client_id": "158219607556-m8pcp6soiia4p61p72ntuf4amuf2lrqi.apps.googleusercontent.com",
		"client_secret": "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"
	},
	"crossmint": {
		"project_id": "ck_staging_9yiAym64NJTiNgUmtGmDDsfc8b3pExdhyhFUtPqytLZN9ER83c5kPtpGbR7FJdT1TNCxRN5SVrFK6NNKKmKJcH4sDMy7tFpdHzN55yTfnz6vuW2w9gMsKYY7zZWgo31iueLFjBhQWPVVjJ4gdXknzntdJA5GqTkTyibJhnnzp9dPBqwHbzTwneGAPioEA2TYzsS9eQ6XsWCynUakLQCVBCZo",
		"client_secret": "sk_staging_32yTH2qGiXh38BJczqRyEnv9sCnx7LQGdQcuY8Sbe1MUSt578PT8EcZnm7g5vSgJ4Tg1uSsmPajLPQUxvPZTVvw9gsAYvZojsMZMGE9qiQLdsHZ5Pwa7wxbkcN75MSv7QwkSg578WgiXtEPSjSo6dm9QHdQpfAxpe7LS78NCMgnMhiRFwvajTJsuJqBwM6HJUJHeGHooyWBCNFQs3EwPgwz",
		"collection_id": "99c73553-160c-4b65-b288-e294d173336b"
	}
}

static var config := ConfigFile.new()
static var _loaded := false

## Retrieves a secret. Priority: 1. BAKED_SECRETS, 2. OS Env, 3. secrets.cfg
static func get_secret(section: String, key: String, default_val: String = "") -> String:
	# 1. Check BAKED_SECRETS first
	if BAKED_SECRETS.has(section) and BAKED_SECRETS[section].has(key):
		var val = str(BAKED_SECRETS[section][key]).strip_edges()
		if not val.is_empty() and val != "YOUR_GOOGLE_CLIENT_ID" and val != "YOUR_SUPABASE_URL":
			# Only log in editor to avoid leaking presence of keys in production logs if not needed,
			# but it's helpful for debugging standalone builds.
			if OS.has_feature("editor"):
				print("[Env] Using baked secret for: ", section, "/", key)
			return val

	# 2. Try OS Environment Variable (e.g. GOOGLE_CLIENT_ID or SUPABASE_URL)
	var env_key = (section + "_" + key).to_upper()
	var env_val = OS.get_environment(env_key).strip_edges()
	if not env_val.is_empty():
		print("[Env] Using environment variable for: ", env_key)
		return env_val

	# 3. Fallback to secrets.cfg (External file)
	if not _loaded:
		_load_config()
	
	var config_val = config.get_value(section, key, "").strip_edges()
	if not config_val.is_empty():
		return config_val

	if not default_val.is_empty():
		return default_val
		
	# Final Warning: If we get here, the API will likely fail.
	if not OS.has_feature("editor"):
		print("[Env] WARNING: No secret found for ", section, "/", key, ". API calls may fail.")
	
	return ""

static func _load_config() -> void:
	var paths = [
		"res://secrets.cfg",
		OS.get_executable_path().get_base_dir().path_join("secrets.cfg")
	]
	
	# Mobile/Android often needs a specific user path if the dev wants to push a config manually
	if OS.has_feature("mobile"):
		paths.append("user://secrets.cfg")
		
	var success = false
	for path in paths:
		if FileAccess.file_exists(path):
			var err = config.load(path)
			if err == OK:
				print("[Env] Loaded external configuration from: ", path)
				success = true
				break
	_loaded = true
