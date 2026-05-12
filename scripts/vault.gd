extends Control

# ── Vault System (Optimized & Cached) ──
# Handles collection display with disk-caching and robust layout management.

const HOME_SCENE = "res://screens/home.tscn"

# ── Visual Constants ───────────────────────────────────────────────────────────
const C_BG      : Color = Color(0.04, 0.03, 0.10)
const C_PANEL   : Color = Color(0.12, 0.08, 0.24)
const C_PINK    : Color = Color(0.96, 0.42, 0.62)
const C_GOLD    : Color = Color(0.98, 0.8, 0.1)
const C_CREAM   : Color = Color(0.96, 0.91, 0.78)
const C_MUTED   : Color = Color(0.55, 0.55, 0.65)
const C_BLACK_TR : Color = Color(0, 0, 0, 0.6)

var pixel_font : FontFile
var body_font  : FontFile

# ── UI Nodes ───────────────────────────────────────────────────────────────────
var grid_container : GridContainer
var scroll_area    : ScrollContainer
var av_tab_btn     : Button
var nft_tab_btn    : Button
var empty_state    : VBoxContainer

# ── Lifecycle ──────────────────────────────────────────────────────────────────
func _ready() -> void:
	print("[VAULT] Scene Ready.")
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	
	# Ensure cache directory exists
	var cache_dir = AuthManager.get_vault_cache_dir()
	if not DirAccess.dir_exists_absolute(cache_dir):
		DirAccess.make_dir_absolute(cache_dir)
		
	print("[VAULT] Initialized. Cache: ", cache_dir)
	
	# Reactive Refresh
	if not AuthManager.login_success.is_connected(_on_refresh_data):
		AuthManager.login_success.connect(_on_refresh_data)
	if not AuthManager.profile_updated.is_connected(_on_refresh_data):
		AuthManager.profile_updated.connect(_on_refresh_data)
	
	_build_ui()
	resized.connect(_on_resized)
	_on_resized()
	_load_avatars()

func _on_resized() -> void:
	if grid_container == null: return
	var avail_w = get_rect().size.x - 120 # Left/Right margins
	var card_w = 300
	var sep = 30
	var cols = floor((avail_w + sep) / (card_w + sep))
	grid_container.columns = max(1, int(cols))

func _exit_tree() -> void:
	print("[VAULT] Scene Exited.")

func _on_refresh_data(_u = null) -> void:
	# Check current tab and refresh
	if av_tab_btn.modulate == Color.WHITE:
		_load_avatars()
	else:
		_load_nfts()

# ══════════════════════════════════════════════════════════════════════════════
# UI ARCHITECTURE
# ══════════════════════════════════════════════════════════════════════════════

func _build_ui() -> void:
	# 1. Background
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	# 2. Layout Container
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left",   60)
	margin.add_theme_constant_override("margin_right",  60)
	margin.add_theme_constant_override("margin_top",    60)
	margin.add_theme_constant_override("margin_bottom", 60)
	add_child(margin)

	var main_vbox := VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 35)
	margin.add_child(main_vbox)

	# 3. Header
	var header := HBoxContainer.new()
	header.custom_minimum_size = Vector2(0, 80)
	main_vbox.add_child(header)

	var title := Label.new()
	title.text = "COLLECTION VAULT"
	title.add_theme_font_size_override("font_size", 52)
	title.add_theme_color_override("font_color", C_CREAM)
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	header.add_child(title)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	var back_btn := _styled_button("BACK TO HOME", C_PINK, Color.WHITE)
	back_btn.pressed.connect(func(): get_tree().change_scene_to_file(HOME_SCENE))
	header.add_child(back_btn)

	# 4. Navigation
	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 20)
	main_vbox.add_child(nav)

	av_tab_btn = _tab_button("AVATARS", C_PINK)
	av_tab_btn.pressed.connect(_load_avatars)
	nav.add_child(av_tab_btn)

	nft_tab_btn = _tab_button("NFTS", C_GOLD)
	nft_tab_btn.pressed.connect(_load_nfts)
	nav.add_child(nft_tab_btn)

	# 5. Content Stack
	var stack = PanelContainer.new()
	stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	main_vbox.add_child(stack)

	scroll_area = ScrollContainer.new()
	scroll_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_area.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	scroll_area.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_area.vertical_scroll_mode   = ScrollContainer.SCROLL_MODE_AUTO
	stack.add_child(scroll_area)

	grid_container = GridContainer.new()
	grid_container.columns = 3
	grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid_container.size_flags_vertical   = Control.SIZE_SHRINK_BEGIN
	grid_container.add_theme_constant_override("h_separation", 30)
	grid_container.add_theme_constant_override("v_separation", 30)
	scroll_area.add_child(grid_container)

	empty_state = VBoxContainer.new()
	empty_state.alignment = BoxContainer.ALIGNMENT_CENTER
	empty_state.visible = false
	empty_state.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	empty_state.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	stack.add_child(empty_state)
	
	var empty_lbl = Label.new()
	empty_lbl.text = "VAULT IS EMPTY"
	empty_lbl.add_theme_color_override("font_color", C_MUTED)
	empty_lbl.add_theme_font_size_override("font_size", 24)
	if pixel_font: empty_lbl.add_theme_font_override("font", pixel_font)
	empty_state.add_child(empty_lbl)

# ══════════════════════════════════════════════════════════════════════════════
# DATA LOADING
# ══════════════════════════════════════════════════════════════════════════════

func _load_avatars() -> void:
	_clear_view()
	_set_active_tab("avatar")
	var history = AuthManager.current_user.get("avatar_history", [])
	if history.is_empty():
		_toggle_empty(true)
	else:
		_toggle_empty(false)
		for i in history.size(): _create_item_card(str(history[i]), "avatar", i)

func _load_nfts() -> void:
	_clear_view()
	_set_active_tab("nft")
	var history = AuthManager.current_user.get("nft_history", [])
	if history.is_empty():
		_toggle_empty(true)
	else:
		_toggle_empty(false)
		for i in history.size():
			var data = history[i]
			var url = data.get("url", "") if data is Dictionary else str(data)
			_create_item_card(url, "nft", i, data if data is Dictionary else {})

func _create_item_card(url: String, type: String, idx: int, meta: Dictionary = {}) -> void:
	if url.is_empty(): return

	# 1. The Container (Card)
	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(300, 300)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = C_PANEL
	style.border_width_left = 6; style.border_width_right = 6
	style.border_width_top = 6; style.border_width_bottom = 6
	var is_active = (type == "avatar" and url == AuthManager.current_user.get("avatar_url", ""))
	style.border_color = Color.WHITE if is_active else (C_PINK if type == "avatar" else C_GOLD)
	style.set_corner_radius_all(0)
	style.shadow_color = Color(0,0,0,0.5); style.shadow_size = 6; style.shadow_offset = Vector2(8,8)
	card.add_theme_stylebox_override("panel", style)
	grid_container.add_child(card)

	# 2. Image Layer
	var tex := TextureRect.new()
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	card.add_child(tex)

	# 3. Overlay Layer
	var overlay = VBoxContainer.new()
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(overlay)

	if is_active:
		var b = _badge("ACTIVE", Color.WHITE, Color.BLACK)
		overlay.add_child(b)

	var sp = Control.new(); sp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay.add_child(sp)

	if type == "nft":
		var info = PanelContainer.new()
		var s = StyleBoxFlat.new(); s.bg_color = C_BLACK_TR
		info.add_theme_stylebox_override("panel", s)
		overlay.add_child(info)
		var l = Label.new()
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_font_size_override("font_size", 10)
		if body_font: l.add_theme_font_override("font", body_font)
		var ts = meta.get("timestamp", 0)
		if ts > 0:
			var d = Time.get_datetime_dict_from_unix_time(int(ts))
			l.text = "MINTED: %02d/%02d" % [d.day, d.month]
		else: l.text = "COLLECTIBLE"
		info.add_child(l)

	# 5. Load Logic (Cache-First)
	var cache_dir = AuthManager.get_vault_cache_dir()
	var cache_path = cache_dir + str(url.hash()) + ".png"
	var avatar_path = AuthManager.get_active_avatar_path()
	
	# Priority 1: Check Global Active Cache
	if is_active and FileAccess.file_exists(avatar_path):
		_set_texture_from_path(avatar_path, tex)
	# Priority 2: Check Vault Cache
	elif FileAccess.file_exists(cache_path):
		_set_texture_from_path(cache_path, tex)
	# Priority 3: Fetch Remote
	else:
		_fetch_remote(url, tex, cache_path, card)

	# 6. Interaction
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	card.mouse_entered.connect(func():
		create_tween().tween_property(card, "modulate", Color(1.2, 1.2, 1.2), 0.1)
		AudioManager.play("hover")
	)
	card.mouse_exited.connect(func():
		create_tween().tween_property(card, "modulate", Color(1.0, 1.0, 1.0), 0.1)
	)
	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if type == "avatar": _apply_choice(url)
	)

# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

func _set_texture_from_path(path: String, tex: TextureRect) -> void:
	if not FileAccess.file_exists(path):
		print("[VAULT] ERR: File not found for loading: ", path)
		return
		
	var img := Image.load_from_file(path)
	if img:
		tex.texture = ImageTexture.create_from_image(img)
		print("[VAULT] Loaded from disk: ", path)
	else:
		print("[VAULT] ERR: Failed to load image data at: ", path)

func _fetch_remote(url: String, tex: TextureRect, cache_path: String, parent: Node) -> void:
	UIUtils.add_shimmer(tex)
	var http = HTTPRequest.new()
	parent.add_child(http)
	http.request_completed.connect(func(_r, code, _h, body):
		if not is_instance_valid(tex): return
		UIUtils.remove_shimmer(tex)
		
		if code == 200:
			var img = Image.new()
			# Try to decode the buffer to verify it's a valid image before saving
			if img.load_jpg_from_buffer(body) == OK or img.load_png_from_buffer(body) == OK or img.load_webp_from_buffer(body) == OK:
				# 1. Save to disk first (User's requested "Import" method)
				var err = img.save_png(cache_path)
				if err == OK:
					print("[VAULT] Successfully cached to disk: ", cache_path)
					# 2. Now load it from the disk location
					_set_texture_from_path(cache_path, tex)
				else:
					print("[VAULT] ERR: Failed to save to cache: ", err)
					# Fallback: set directly if save fails
					tex.texture = ImageTexture.create_from_image(img)
		else:
			print("[VAULT] HTTP Download Failed: ", code)
	)
	http.request(url)

func _apply_choice(url: String) -> void:
	AudioManager.play("success")
	AuthManager.current_user["avatar_url"] = url
	AuthManager.update_user_details({"avatar_url": url})
	UIUtils.show_toast("Identity Updated!", C_PINK)
	_load_avatars()

func _clear_view() -> void:
	for c in grid_container.get_children(): c.queue_free()

func _toggle_empty(is_empty: bool) -> void:
	empty_state.visible = is_empty
	scroll_area.visible = !is_empty

func _set_active_tab(type: String) -> void:
	var av = (type == "avatar")
	av_tab_btn.modulate = Color.WHITE if av else Color(0.6, 0.6, 0.7)
	nft_tab_btn.modulate = Color.WHITE if !av else Color(0.6, 0.6, 0.7)

func _badge(txt: String, bg: Color, fg: Color) -> Label:
	var l = Label.new(); l.text = " " + txt + " "
	l.add_theme_color_override("font_color", fg)
	l.add_theme_font_size_override("font_size", 10)
	if pixel_font: l.add_theme_font_override("font", pixel_font)
	var s = StyleBoxFlat.new(); s.bg_color = bg; l.add_theme_stylebox_override("normal", s)
	l.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	return l

func _tab_button(txt: String, col: Color) -> Button:
	var btn := Button.new(); btn.text = txt
	btn.custom_minimum_size = Vector2(200, 55)
	var s := StyleBoxFlat.new(); s.bg_color = col.darkened(0.3)
	s.border_width_bottom = 4; s.border_color = col
	btn.add_theme_stylebox_override("normal", s); btn.add_theme_stylebox_override("hover", s); btn.add_theme_stylebox_override("pressed", s)
	if pixel_font: btn.add_theme_font_override("font", pixel_font)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return btn

func _styled_button(txt: String, col: Color, txt_col: Color) -> Button:
	var btn := Button.new(); btn.text = txt
	btn.custom_minimum_size = Vector2(180, 48)
	var s := StyleBoxFlat.new(); s.bg_color = col; btn.add_theme_stylebox_override("normal", s)
	btn.add_theme_color_override("font_color", txt_col)
	if pixel_font: btn.add_theme_font_override("font", pixel_font)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return btn
