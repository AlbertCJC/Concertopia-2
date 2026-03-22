extends VBoxContainer

@onready var box1: LineEdit        = $HBoxContainer/box1
@onready var box2: LineEdit        = $HBoxContainer/box2
@onready var box3: LineEdit        = $HBoxContainer/box3
@onready var box4: LineEdit        = $HBoxContainer/box4
@onready var submit_button: Button = $submit
@onready var cancel_button: Button = $cancel
var error_label: Label = null

const LOGIN_SCENE       := "res://screens/login.tscn"
const CHANGE_PASS_SCENE := "res://screens/changepass.tscn"
const FORGOT_SCENE      := "res://screens/forgot password .tscn"

func _ready() -> void:
	_configure_box(box1)
	_configure_box(box2)
	_configure_box(box3)
	_configure_box(box4)

	box1.text_changed.connect(_on_box_changed.bind(box1, box2))
	box2.text_changed.connect(_on_box_changed.bind(box2, box3))
	box3.text_changed.connect(_on_box_changed.bind(box3, box4))
	box4.text_changed.connect(_on_box4_changed)

	submit_button.pressed.connect(_on_submit_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

	AuthManager.reset_code_verified.connect(_on_code_verified)
	AuthManager.reset_code_invalid.connect(_on_code_invalid)

	_ensure_error_label()
	box1.grab_focus()

func _configure_box(box: LineEdit) -> void:
	box.max_length = 1
	box.alignment  = HORIZONTAL_ALIGNMENT_CENTER
	box.context_menu_enabled = false

func _on_box_changed(new_text: String, current_box: LineEdit, next_box: LineEdit) -> void:
	if new_text.length() == 1:
		if not new_text.is_valid_int():
			current_box.text = ""
			return
		next_box.grab_focus()
	_show_error("")

func _on_box4_changed(new_text: String) -> void:
	if new_text.length() == 1:
		if not new_text.is_valid_int():
			box4.text = ""
			return
		if _get_full_code().length() == 4:
			_attempt_verify()

func _get_full_code() -> String:
	return box1.text + box2.text + box3.text + box4.text

func _on_submit_pressed() -> void:
	_attempt_verify()

func _attempt_verify() -> void:
	var code := _get_full_code()
	if code.length() < 4:
		_show_error("Please enter all 4 digits.")
		return
	_show_error("")
	submit_button.disabled = true
	submit_button.text = "Verifying..."
	AuthManager.verify_reset_code(code)

func _on_code_verified() -> void:
	submit_button.disabled = false
	submit_button.text = "Submit"
	get_tree().change_scene_to_file.call_deferred(CHANGE_PASS_SCENE)

func _on_code_invalid() -> void:
	submit_button.disabled = false
	submit_button.text = "Submit"
	_show_error("Incorrect code. Please try again.")
	box1.text = ""
	box2.text = ""
	box3.text = ""
	box4.text = ""
	box1.grab_focus()

func _on_cancel_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(FORGOT_SCENE)

func _ensure_error_label() -> void:
	error_label = Label.new()
	error_label.name = "ErrorLabel"
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	error_label.visible = false
	add_child(error_label)
	move_child(error_label, submit_button.get_index())

func _show_error(message: String) -> void:
	if error_label == null:
		return
	error_label.text    = message
	error_label.visible = not message.is_empty()
