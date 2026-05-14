class_name Env

static var config := ConfigFile.new()
static var _loaded := false

static func get_secret(section: String, key: String, default_val: String = "") -> String:
	if not _loaded:
		var err = config.load("res://secrets.cfg")
		if err != OK:
			push_error("Failed to load res://secrets.cfg (Error: " + str(err) + "). Ensure the file exists.")
		_loaded = true
	return config.get_value(section, key, default_val)
