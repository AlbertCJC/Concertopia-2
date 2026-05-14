extends Node

# ── Audio Manager ──
# Handles global SFX playback for UI consistency.

var _sfx_players : Array[AudioStreamPlayer] = []
const POOL_SIZE : int = 8

var _sounds : Dictionary = {
	"hover":    "res://audio/sfx/hover.wav",
	"click":    "res://audio/sfx/click.wav",
	"success":  "res://audio/sfx/success.wav",
	"error":    "res://audio/sfx/error.wav",
	"generate": "res://audio/sfx/generate.wav",
	"reward":   "res://audio/sfx/reward.wav"
}

var _loaded_streams : Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pre-create a pool of players to avoid latency
	for i in POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)
	
	_load_sounds()
	_restore_settings()

func _load_sounds() -> void:
	for key in _sounds:
		var path = _sounds[key]
		# In exported builds, .wav files are remapped to .wav.import or internal formats.
		# load() handles this automatically, but FileAccess.file_exists() might fail on the original path.
		var stream = load(path)
		if stream:
			_loaded_streams[key] = stream
		else:
			# Soft warning, won't crash
			print("[AudioManager] Failed to load sound: ", path)

## ── Settings Management ──

func set_sfx_enabled(enabled: bool) -> void:
	var idx = AudioServer.get_bus_index("SFX")
	if idx != -1:
		AudioServer.set_bus_mute(idx, not enabled)
	_save_setting("sfx_enabled", enabled)

func is_sfx_enabled() -> bool:
	var idx = AudioServer.get_bus_index("SFX")
	if idx != -1:
		return not AudioServer.is_bus_mute(idx)
	return true

func set_music_enabled(enabled: bool) -> void:
	var idx = AudioServer.get_bus_index("Music")
	if idx != -1:
		AudioServer.set_bus_mute(idx, not enabled)
	_save_setting("music_enabled", enabled)

func is_music_enabled() -> bool:
	var idx = AudioServer.get_bus_index("Music")
	if idx != -1:
		return not AudioServer.is_bus_mute(idx)
	return true

func _save_setting(key: String, value: Variant) -> void:
	var settings = {}
	if FileAccess.file_exists("user://app_settings.json"):
		var f = FileAccess.open("user://app_settings.json", FileAccess.READ)
		settings = JSON.parse_string(f.get_as_text())
		if settings == null: settings = {}
	
	settings[key] = value
	var f_out = FileAccess.open("user://app_settings.json", FileAccess.WRITE)
	f_out.store_string(JSON.stringify(settings))

func _restore_settings() -> void:
	if not FileAccess.file_exists("user://app_settings.json"):
		return
	var f = FileAccess.open("user://app_settings.json", FileAccess.READ)
	var settings = JSON.parse_string(f.get_as_text())
	if settings is Dictionary:
		if settings.has("sfx_enabled"): set_sfx_enabled(settings["sfx_enabled"])
		if settings.has("music_enabled"): set_music_enabled(settings["music_enabled"])

## ── Playback ──
func play(sfx_name: String, pitch_rnd: float = 0.0) -> void:
	if not _loaded_streams.has(sfx_name):
		return
		
	var player = _get_available_player()
	if player:
		player.stream = _loaded_streams[sfx_name]
		player.pitch_scale = 1.0 + randf_range(-pitch_rnd, pitch_rnd)
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for p in _sfx_players:
		if not p.playing:
			return p
	return _sfx_players[0] # Overwrite first if all busy
