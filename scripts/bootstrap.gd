extends Node

# ── Configuration ──────────────────────────────────────────────────────────────
const LOGO_PATH   := "res://icons/Concertopia.png"
const BG_COLOR    := Color(0.06, 0.04, 0.14) # Deep Concertopia Purple
const GOLD_COLOR  := Color(0.78, 0.59, 0.35) # Branded Gold
const TEXT_COLOR  := Color(0.96, 0.91, 0.78) # Cream

# ── UI References ──────────────────────────────────────────────────────────────
var progress_bar  : ProgressBar
var status_label  : Label
var logo_rect     : TextureRect

func _ready() -> void:
	_build_loading_ui()
	_start_boot_sequence()

func _build_loading_ui() -> void:
	# CanvasLayer to ensure it's on top
	var cl = CanvasLayer.new()
	add_child(cl)
	
	# Background
	var bg = ColorRect.new()
	bg.color = BG_COLOR
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cl.add_child(bg)
	
	# Center Container for logo
	var center = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cl.add_child(center)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 40)
	center.add_child(vbox)
	
	# Logo
	logo_rect = TextureRect.new()
	logo_rect.texture = load(LOGO_PATH)
	logo_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo_rect.custom_minimum_size = Vector2(300, 300)
	logo_rect.modulate.a = 0 # For fading in
	vbox.add_child(logo_rect)
	
	# Progress Bar
	progress_bar = ProgressBar.new()
	progress_bar.custom_minimum_size = Vector2(400, 10)
	progress_bar.show_percentage = false
	
	# Style the Progress Bar
	var sb_bg = StyleBoxFlat.new()
	sb_bg.bg_color = Color(0.12, 0.08, 0.24)
	sb_bg.set_corner_radius_all(5)
	
	var sb_fg = StyleBoxFlat.new()
	sb_fg.bg_color = GOLD_COLOR
	sb_fg.set_corner_radius_all(5)
	
	progress_bar.add_theme_stylebox_override("background", sb_bg)
	progress_bar.add_theme_stylebox_override("fill", sb_fg)
	vbox.add_child(progress_bar)
	
	# Status Label
	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.text = "Initializing Concertopia..."
	status_label.add_theme_color_override("font_color", TEXT_COLOR)
	# Use a font if available, fallback to default
	var font = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf")
	if font: status_label.add_theme_font_override("font", font)
	status_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(status_label)

func _start_boot_sequence() -> void:
	# 1. Fade in Logo
	var tween = create_tween().set_parallel(true)
	tween.tween_property(logo_rect, "modulate:a", 1.0, 0.8)
	tween.tween_property(progress_bar, "value", 20.0, 0.5)
	
	await tween.finished
	
	# 2. Simulate/Perform checks
	status_label.text = "Loading Assets..."
	await get_tree().create_timer(0.4).timeout
	progress_bar.value = 50
	
	status_label.text = "Syncing Environment..."
	await get_tree().create_timer(0.3).timeout
	progress_bar.value = 85
	
	status_label.text = "Ready!"
	progress_bar.value = 100
	await get_tree().create_timer(0.2).timeout
	
	# 3. Transition to the actual startup scene
	get_tree().change_scene_to_file.call_deferred(FirstLaunch.get_startup_scene())
