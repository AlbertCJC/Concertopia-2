extends Control
# Onboarding Screen 2 of 3 — "Discover"

@onready var next_button: Button   = $CenterContainer/VBoxContainer/"Log In2"
@onready var title_label: Label    = $CenterContainer/VBoxContainer/"Log In"
@onready var email_field: LineEdit = $CenterContainer/VBoxContainer/Email
@onready var pass_field: LineEdit  = $CenterContainer/VBoxContainer/Passwowrd
@onready var signup_label: Label   = $CenterContainer/VBoxContainer/Label
@onready var or_label: Label       = $CenterContainer/VBoxContainer/continue
@onready var social_box: HBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer

const DOT_ACTIVE   := Color(1.0, 1.0, 1.0, 1.0)
const DOT_INACTIVE := Color(1.0, 1.0, 1.0, 0.3)
const NEXT_SCENE   := "res://screens/welcome_screen3.tscn"
const PREV_SCENE   := "res://screens/welcome_screen1.tscn"

func _ready() -> void:
	title_label.text = "🗺️  Discover Nearby Shows"
	next_button.text = "Next  →"

	email_field.visible  = false
	pass_field.visible   = false
	signup_label.visible = false
	or_label.visible     = false
	social_box.visible   = false

	# Subtitle
	var subtitle := Label.new()
	subtitle.text = "Browse concerts by genre, artist, or venue.\nFind shows happening right in your city."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	$CenterContainer/VBoxContainer.add_child(subtitle)
	$CenterContainer/VBoxContainer.move_child(subtitle, title_label.get_index() + 1)

	# Back label
	var back_label := Label.new()
	back_label.text = "← Back"
	back_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	back_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	back_label.mouse_filter = Control.MOUSE_FILTER_STOP
	back_label.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	back_label.gui_input.connect(_on_back_input)
	$CenterContainer/VBoxContainer.add_child(back_label)
	$CenterContainer/VBoxContainer.move_child(back_label, next_button.get_index() + 1)

	# Dots
	_build_dots(1)

	next_button.pressed.connect(_go_next)

func _build_dots(active_index: int) -> void:
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 10)
	for i in 3:
		var dot := ColorRect.new()
		dot.custom_minimum_size = Vector2(28, 10) if i == active_index else Vector2(10, 10)
		dot.color = DOT_ACTIVE if i == active_index else DOT_INACTIVE
		hbox.add_child(dot)
	$CenterContainer/VBoxContainer.add_child(hbox)
	$CenterContainer/VBoxContainer.move_child(hbox, next_button.get_index())

func _go_next() -> void:
	get_tree().change_scene_to_file(NEXT_SCENE)

func _on_back_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file(PREV_SCENE)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if event.relative.x < -60:
			_go_next()
		elif event.relative.x > 60:
			get_tree().change_scene_to_file(PREV_SCENE)
