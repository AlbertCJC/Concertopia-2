extends Control

const NEXT_SCENE : String = "res://screens/welcome_screen1.tscn"

var pixel_font : FontFile
var display_name_edit : LineEdit
var full_name_edit : LineEdit
var age_edit : LineEdit
var bio_edit : TextEdit
var submit_button : Button
var error_label : Label

func _ready() -> void:
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	margin.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 20)
	scroll.add_child(vbox)

	var title := Label.new()
	title.text = "Signup Info"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.96, 0.42, 0.62))
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Tell us a bit about yourself"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	if pixel_font: subtitle.add_theme_font_override("font", pixel_font)
	vbox.add_child(subtitle)

	vbox.add_child(_create_spacer(10))

	display_name_edit = _create_input_field(vbox, "Display Name", "How others see you")
	full_name_edit = _create_input_field(vbox, "Full Name", "Your real name")
	age_edit = _create_input_field(vbox, "Age", "e.g. 21")
	
	# Bio field
	var bio_label := Label.new()
	bio_label.text = "Bio / Information"
	bio_label.add_theme_font_size_override("font_size", 14)
	if pixel_font: bio_label.add_theme_font_override("font", pixel_font)
	vbox.add_child(bio_label)
	
	bio_edit = TextEdit.new()
	bio_edit.custom_minimum_size = Vector2(0, 100)
	bio_edit.placeholder_text = "Tell us about your music taste..."
	bio_edit.add_theme_font_size_override("font_size", 14)
	bio_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	vbox.add_child(bio_edit)

	error_label = Label.new()
	error_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	error_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	error_label.add_theme_font_size_override("font_size", 12)
	error_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	error_label.visible = false
	if pixel_font: error_label.add_theme_font_override("font", pixel_font)
	vbox.add_child(error_label)

	submit_button = Button.new()
	submit_button.text = "Continue"
	submit_button.custom_minimum_size = Vector2(0, 50)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.96, 0.42, 0.62)
	sb.set_corner_radius_all(10)
	submit_button.add_theme_stylebox_override("normal", sb)
	submit_button.add_theme_stylebox_override("hover", sb)
	submit_button.add_theme_stylebox_override("pressed", sb)
	submit_button.add_theme_font_size_override("font_size", 20)
	if pixel_font: submit_button.add_theme_font_override("font", pixel_font)
	submit_button.pressed.connect(_on_submit_pressed)
	vbox.add_child(submit_button)

	# Pre-fill display name if available
	if AuthManager.current_user.has("display_name"):
		display_name_edit.text = AuthManager.current_user["display_name"]

func _create_input_field(parent: Node, label_text: String, placeholder: String) -> LineEdit:
	var lbl := Label.new()
	lbl.text = label_text
	lbl.add_theme_font_size_override("font_size", 14)
	if pixel_font: lbl.add_theme_font_override("font", pixel_font)
	parent.add_child(lbl)
	
	var edit := LineEdit.new()
	edit.placeholder_text = placeholder
	edit.add_theme_font_size_override("font_size", 14)
	parent.add_child(edit)
	return edit

func _create_spacer(height: float) -> Control:
	var sp := Control.new()
	sp.custom_minimum_size = Vector2(0, height)
	return sp

func _on_submit_pressed() -> void:
	var d_name : String = display_name_edit.text.strip_edges()
	var f_name : String = full_name_edit.text.strip_edges()
	var age_str : String = age_edit.text.strip_edges()
	var bio : String = bio_edit.text.strip_edges()

	if d_name.is_empty():
		_show_error("Display name is required.")
		return
	
	var age : int = age_str.to_int()
	if age <= 0 and not age_str.is_empty():
		_show_error("Please enter a valid age.")
		return

	AuthManager.update_user_details({
		"display_name": d_name,
		"full_name": f_name,
		"age": age,
		"bio": bio
	})

	ScreenTransition.go(NEXT_SCENE, "left")

func _show_error(msg: String) -> void:
	error_label.text = msg
	error_label.visible = !msg.is_empty()
