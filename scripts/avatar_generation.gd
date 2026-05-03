extends Control

const NEXT_SCENE : String = "res://screens/welcome_screen1.tscn"

# ── Colors ─────────────────────────────────────────────────────────────────────
const C_BG      : Color = Color(0.04, 0.03, 0.10)
const C_PANEL   : Color = Color(0.12, 0.08, 0.24)
const C_PINK    : Color = Color(0.96, 0.42, 0.62)
const C_CREAM   : Color = Color(0.96, 0.91, 0.78)
const C_MUTED   : Color = Color(0.55, 0.55, 0.65)

var pixel_font : FontFile
var body_font  : FontFile

var prompt_edit : LineEdit
var generate_btn : Button
var continue_btn : Button
var avatar_rect : TextureRect
var http_request : HTTPRequest
var status_label : Label

func _ready() -> void:
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var card := PanelContainer.new()
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = C_PANEL
	card_style.set_corner_radius_all(20)
	card_style.content_margin_left = 40
	card_style.content_margin_right = 40
	card_style.content_margin_top = 40
	card_style.content_margin_bottom = 40
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 25)
	card.add_child(main_vbox)

	var title := Label.new()
	title.text = "CREATE YOUR AVATAR"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", C_PINK)
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	main_vbox.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Describe your ideal pixel art avatar"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", C_MUTED)
	if body_font: subtitle.add_theme_font_override("font", body_font)
	main_vbox.add_child(subtitle)

	avatar_rect = TextureRect.new()
	avatar_rect.custom_minimum_size = Vector2(200, 200)
	avatar_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	avatar_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var default_tex = load("res://icons/user.png") as Texture2D
	if default_tex:
		avatar_rect.texture = default_tex
	main_vbox.add_child(avatar_rect)

	prompt_edit = LineEdit.new()
	prompt_edit.placeholder_text = "e.g. A cool cyberpunk DJ"
	prompt_edit.custom_minimum_size = Vector2(300, 45)
	var p_style := StyleBoxFlat.new()
	p_style.bg_color = Color(1, 1, 1, 1)
	p_style.set_corner_radius_all(10)
	p_style.content_margin_left = 15
	prompt_edit.add_theme_stylebox_override("normal", p_style)
	prompt_edit.add_theme_color_override("font_color", Color.BLACK)
	prompt_edit.add_theme_color_override("caret_color", Color(0.1, 0.1, 0.1, 1))
	if body_font: prompt_edit.add_theme_font_override("font", body_font)
	main_vbox.add_child(prompt_edit)

	var sample_prompts := Label.new()
	sample_prompts.text = "Try: A neon samurai, A fantasy wizard, A retro robot"
	sample_prompts.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sample_prompts.add_theme_font_size_override("font_size", 12)
	sample_prompts.add_theme_color_override("font_color", C_MUTED)
	if body_font: sample_prompts.add_theme_font_override("font", body_font)
	main_vbox.add_child(sample_prompts)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 15)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_child(hbox)

	generate_btn = Button.new()
	generate_btn.text = "GENERATE"
	generate_btn.custom_minimum_size = Vector2(140, 45)
	var g_style := StyleBoxFlat.new()
	g_style.bg_color = C_PINK
	g_style.set_corner_radius_all(10)
	generate_btn.add_theme_stylebox_override("normal", g_style)
	generate_btn.add_theme_stylebox_override("hover", g_style)
	generate_btn.add_theme_stylebox_override("pressed", g_style)
	generate_btn.add_theme_font_size_override("font_size", 16)
	if pixel_font: generate_btn.add_theme_font_override("font", pixel_font)
	generate_btn.pressed.connect(_on_generate_pressed)
	hbox.add_child(generate_btn)

	continue_btn = Button.new()
	continue_btn.text = "SKIP"
	continue_btn.custom_minimum_size = Vector2(140, 45)
	var c_style := StyleBoxFlat.new()
	c_style.bg_color = C_MUTED
	c_style.set_corner_radius_all(10)
	continue_btn.add_theme_stylebox_override("normal", c_style)
	continue_btn.add_theme_stylebox_override("hover", c_style)
	continue_btn.add_theme_stylebox_override("pressed", c_style)
	continue_btn.add_theme_font_size_override("font_size", 16)
	if pixel_font: continue_btn.add_theme_font_override("font", pixel_font)
	continue_btn.pressed.connect(_on_continue_pressed)
	hbox.add_child(continue_btn)

	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.add_theme_color_override("font_color", C_CREAM)
	status_label.visible = false
	if body_font: status_label.add_theme_font_override("font", body_font)
	main_vbox.add_child(status_label)

func _on_generate_pressed() -> void:
	var prompt = prompt_edit.text.strip_edges()
	if prompt.is_empty():
		status_label.text = "Please enter a prompt!"
		status_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
		status_label.visible = true
		return
	
	status_label.text = "Generating... (This may take 10-20 seconds)"
	status_label.add_theme_color_override("font_color", C_CREAM)
	status_label.visible = true
	generate_btn.disabled = true
	continue_btn.disabled = true
	
	var base_prompt = "A close-up headshot avatar featuring only the face of a character in strict, ultra-blocky 16-bit pixel art. The image must show highly aliased construction, built from large, visible, distinct square pixel blocks, with absolutely no smoothing or anti-aliasing. The face is composed of rigid, geometric patches of color. Character description: "
	var style_prompt = ". Use hard cell-shading and a severely constrained retro color palette with sharp light and shadow blocks. The face must be perfectly centered within the frame, leaving a little bit of empty solid background space above the head. The entire focus is on the large, blocky construction and aliased edges of the face itself, set against a solid, flat background. No part of the neck or body is visible."
	var full_prompt = base_prompt + prompt + style_prompt
	# URL encode the prompt
	var safe_prompt = full_prompt.uri_encode()
	var url = "https://image.pollinations.ai/prompt/" + safe_prompt + "?width=512&height=512&nologo=true&model=flux&seed=" + str(randi())
	
	AuthManager.current_user["avatar_url"] = url
	var err = http_request.request(url)
	if err != OK:
		_on_error("Failed to start request")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	generate_btn.disabled = false
	continue_btn.disabled = false
	
	if response_code >= 200 and response_code < 300:
		var image = Image.new()
		
		# Try JPEG
		var err = image.load_jpg_from_buffer(body)
		if err != OK:
			# Try PNG
			err = image.load_png_from_buffer(body)
		if err != OK:
			# Try WebP (Pollinations often serves WebP)
			err = image.load_webp_from_buffer(body)
		
		if err == OK:
			var texture = ImageTexture.create_from_image(image)
			avatar_rect.texture = texture
			status_label.text = "Avatar generated!"
			status_label.add_theme_color_override("font_color", Color(0.4, 1.0, 0.5))
			continue_btn.text = "CONTINUE"
			
			# Save to disk
			var save_path = "user://avatar.png"
			image.save_png(save_path)
			AuthManager.current_user["avatar_path"] = save_path
			
			# Save to database
			var avatar_url = AuthManager.current_user.get("avatar_url", "")
			if not avatar_url.is_empty():
				AuthManager.update_user_details({"avatar_url": avatar_url})
		else:
			# Print the first few characters to see what was returned
			var snippet = body.get_string_from_utf8().substr(0, 100)
			print("[AvatarGen] Decode failed. Body snippet: ", snippet)
			_on_error("Failed to decode image.")
	else:
		_on_error("Failed to generate (Code " + str(response_code) + ")")

func _on_error(msg: String) -> void:
	generate_btn.disabled = false
	continue_btn.disabled = false
	status_label.text = msg
	status_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))

func _on_continue_pressed() -> void:
	if is_inside_tree():
		get_tree().change_scene_to_file(NEXT_SCENE)
