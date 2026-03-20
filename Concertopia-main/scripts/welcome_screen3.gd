extends Control

@onready var next_button: Button       = $CenterContainer/VBoxContainer/"Log In2"
@onready var title_label: Label        = $CenterContainer/VBoxContainer/"Log In"
@onready var email_field: LineEdit     = $CenterContainer/VBoxContainer/Email
@onready var pass_field: LineEdit      = $CenterContainer/VBoxContainer/Passwowrd
@onready var signup_label: Label       = $CenterContainer/VBoxContainer/Label
@onready var or_label: Label           = $CenterContainer/VBoxContainer/continue
@onready var social_box: HBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer

const DOT_ACTIVE   := Color(1.0, 1.0, 1.0, 1.0)
const DOT_INACTIVE := Color(1.0, 1.0, 1.0, 0.3)
const LOGIN_SCENE  := "res://screens/login.tscn"
const PREV_SCENE   := "res://screens/welcome_screen2.tscn"

func _ready() -> void:
	title_label.text = "🎟️  Never Miss a Show"
	next_button.text = "Get Started"

	email_field.visible = false
	pass_field.visible  = false
	or_label.visible    = false
	social_box.visible  = false

	signup_label.text = "Already have an account? Log In"
	signup_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	signup_label.mouse_filter = Control.MOUSE_FILTER_STOP
	signup_label.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	signup_label.gui_input.connect(_on_login_label_input)

	var subtitle := Label.new()
	subtitle.text = "Get personalised recommendations,\nset reminders, and book in seconds."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	$CenterContainer/VBoxContainer.add_child(subtitle)
	$CenterContainer/VBoxContainer.move_child(subtitle, title_label.get_index() + 1)

	var back_label := Label.new()
	back_label.text = "← Back"
	back_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	back_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	back_label.mouse_filter = Control.MOUSE_FILTER_STOP
	back_label.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	back_label.gui_input.connect(_on_back_input)
	$CenterContainer/VBoxContainer.add_child(back_label)
	$CenterContainer/VBoxContainer.move_child(back_label, next_button.get_index() + 1)

	_build_dots(2)
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
	FirstLaunch.mark_onboarding_complete()
	get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)

func _on_back_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().change_scene_to_file.call_deferred(PREV_SCENE)

func _on_login_label_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		FirstLaunch.mark_onboarding_complete()
		get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		if event.relative.x < -60:
			_go_next()
		elif event.relative.x > 60:
			get_tree().change_scene_to_file.call_deferred(PREV_SCENE)
