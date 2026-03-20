extends Control

@onready var next_button: Button       = $CenterContainer/VBoxContainer/"Log In2"
@onready var title_label: Label        = $CenterContainer/VBoxContainer/"Log In"
@onready var email_field: LineEdit     = $CenterContainer/VBoxContainer/Email
@onready var pass_field: LineEdit      = $CenterContainer/VBoxContainer/Passwowrd
@onready var signup_label: Label       = $CenterContainer/VBoxContainer/Label
@onready var or_label: Label           = $CenterContainer/VBoxContainer/continue
@onready var social_box: HBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer

var dots: Array[ColorRect] = []
const DOT_ACTIVE   := Color(1.0, 1.0, 1.0, 1.0)
const DOT_INACTIVE := Color(1.0, 1.0, 1.0, 0.3)
const NEXT_SCENE   := "res://screens/welcome_screen2.tscn"

func _ready() -> void:
	title_label.text = "🎵  Welcome to Concertopia"
	next_button.text = "Next  →"

	email_field.visible  = false
	pass_field.visible   = false
	signup_label.visible = false
	or_label.visible     = false
	social_box.visible   = false

	var subtitle := Label.new()
	subtitle.text = "Discover live concerts, book tickets,\nand never miss your favourite artists."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(1, 1, 1, 0.8))
	$CenterContainer/VBoxContainer.add_child(subtitle)
	$CenterContainer/VBoxContainer.move_child(subtitle, title_label.get_index() + 1)

	_build_dots(0)
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
		dots.append(dot)
	$CenterContainer/VBoxContainer.add_child(hbox)
	$CenterContainer/VBoxContainer.move_child(hbox, next_button.get_index())

func _go_next() -> void:
	get_tree().change_scene_to_file.call_deferred(NEXT_SCENE)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and event.relative.x < -60:
		_go_next()
