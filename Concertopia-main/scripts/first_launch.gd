extends Node
# FirstLaunch autoload — tracks whether the user has seen the onboarding screens.
# On first run, routes to welcome_screen1. On subsequent runs, routes to login.

const PREF_PATH := "user://prefs.json"
var _prefs: Dictionary = {}

func _ready() -> void:
	_load_prefs()

func is_first_launch() -> bool:
	return not _prefs.get("onboarding_complete", false)

func mark_onboarding_complete() -> void:
	_prefs["onboarding_complete"] = true
	_save_prefs()

func get_startup_scene() -> String:
	if is_first_launch():
		return "res://screens/welcome_screen1.tscn"
	return "res://screens/login.tscn"

func _save_prefs() -> void:
	var file = FileAccess.open(PREF_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_prefs))
		file.close()

func _load_prefs() -> void:
	if not FileAccess.file_exists(PREF_PATH):
		return
	var file = FileAccess.open(PREF_PATH, FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var result = JSON.parse_string(text)
		if result is Dictionary:
			_prefs = result
