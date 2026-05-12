extends Control

const HOME_SCENE : String = "res://screens/home.tscn"

# Colors
const C_BG         : Color = Color(0.04, 0.03, 0.10)
const C_PANEL      : Color = Color(0.12, 0.08, 0.24)
const C_PANEL_DARK : Color = Color(0.04, 0.03, 0.10)
const C_GOLD       : Color = Color(0.98, 0.8, 0.1)
const C_GOLD_LIGHT : Color = Color(1.0, 0.9, 0.4)
const C_CREAM      : Color = Color(0.96, 0.91, 0.78)
const C_PINK       : Color = Color(0.96, 0.42, 0.62)
const C_MUTED      : Color = Color(0.55, 0.55, 0.65)

var pixel_font : FontFile
var body_font  : FontFile

func _ready() -> void:
	pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	_build_ui()
	_animate_in()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 60)
	margin.add_theme_constant_override("margin_right", 60)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	add_child(margin)
	
	var main_vbox := VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 30)
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	margin.add_child(main_vbox)
	
	# Top bar with Back button
	var top_hbox := HBoxContainer.new()
	top_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vbox.add_child(top_hbox)
	
	var back_btn := _styled_button("← BACK", C_MUTED, Color.WHITE)
	back_btn.custom_minimum_size = Vector2(100, 40)
	back_btn.pressed.connect(_on_back_pressed)
	top_hbox.add_child(back_btn)
	
	# Title Area
	var title_vbox := VBoxContainer.new()
	title_vbox.add_theme_constant_override("separation", 10)
	title_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_child(title_vbox)
	
	var title := Label.new()
	title.text = "CREDIT STORE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", C_GOLD)
	if pixel_font: title.add_theme_font_override("font", pixel_font)
	title_vbox.add_child(title)
	
	var subtitle := Label.new()
	subtitle.text = "Purchase credits to mint exclusive NFTs and unlock premium avatars."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_color", C_MUTED)
	if body_font: subtitle.add_theme_font_override("font", body_font)
	title_vbox.add_child(subtitle)
	
	# Current Balance
	var credits = AuthManager.current_user.get("avatar_credits", 0)
	var balance_lbl := Label.new()
	balance_lbl.text = "CURRENT BALANCE: %d" % credits
	balance_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	balance_lbl.add_theme_font_size_override("font_size", 18)
	balance_lbl.add_theme_color_override("font_color", C_CREAM)
	if body_font: balance_lbl.add_theme_font_override("font", body_font)
	title_vbox.add_child(balance_lbl)
	
	# Store Packages Grid
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 30)
	grid.add_theme_constant_override("v_separation", 30)
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	main_vbox.add_child(grid)
	
	_add_package(grid, "STARTER PACK", 10, "₱249", C_PANEL)
	_add_package(grid, "COLLECTOR PACK", 25, "₱499", C_PINK)
	_add_package(grid, "WHALE PACK", 100, "₱1499", C_GOLD)

func _add_package(parent: Control, pkg_name: String, amount: int, price: String, accent: Color) -> void:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(240, 320)
	var style := StyleBoxFlat.new()
	style.bg_color = C_PANEL_DARK
	style.border_width_left = 4; style.border_width_right = 4
	style.border_width_top = 4; style.border_width_bottom = 4
	style.border_color = accent
	style.set_corner_radius_all(10)
	style.shadow_color = Color(0, 0, 0, 0.5)
	style.shadow_offset = Vector2(8, 8)
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	panel.add_child(vbox)
	
	var name_lbl := Label.new()
	name_lbl.text = pkg_name
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 20)
	name_lbl.add_theme_color_override("font_color", C_CREAM)
	if pixel_font: name_lbl.add_theme_font_override("font", pixel_font)
	vbox.add_child(name_lbl)
	
	var amt_lbl := Label.new()
	amt_lbl.text = str(amount)
	amt_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amt_lbl.add_theme_font_size_override("font_size", 54)
	amt_lbl.add_theme_color_override("font_color", accent)
	if pixel_font: amt_lbl.add_theme_font_override("font", pixel_font)
	vbox.add_child(amt_lbl)
	
	var lbl := Label.new()
	lbl.text = "CREDITS"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 14)
	lbl.add_theme_color_override("font_color", C_MUTED)
	if body_font: lbl.add_theme_font_override("font", body_font)
	vbox.add_child(lbl)
	
	var buy_btn := _styled_button(price, accent, C_PANEL_DARK if accent == C_GOLD else Color.WHITE)
	buy_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	buy_btn.pressed.connect(func(): _on_buy_pressed(amount))
	vbox.add_child(buy_btn)
	
	# Hover effect for package cards
	panel.mouse_entered.connect(func():
		var tw = create_tween().set_parallel(true)
		tw.tween_property(panel, "scale", Vector2(1.05, 1.05), 0.1)
		panel.pivot_offset = panel.size / 2
	)
	panel.mouse_exited.connect(func():
		var tw = create_tween().set_parallel(true)
		tw.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.1)
	)
	
	parent.add_child(panel)

func _styled_button(txt: String, col: Color, txt_col: Color) -> Button:
	var btn := Button.new()
	btn.text = txt
	btn.custom_minimum_size = Vector2(160, 48)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var style := StyleBoxFlat.new()
	style.bg_color = col.darkened(0.2)
	style.set_corner_radius_all(8)
	style.border_width_left = 2; style.border_width_right = 2
	style.border_width_top = 2; style.border_width_bottom = 2
	style.border_color = col
	
	var hov = style.duplicate(); hov.bg_color = col
	var pre = style.duplicate(); pre.bg_color = col.darkened(0.4)
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", hov)
	btn.add_theme_stylebox_override("pressed", pre)
	btn.add_theme_color_override("font_color", txt_col)
	btn.add_theme_color_override("font_hover_color", txt_col)
	if pixel_font: btn.add_theme_font_override("font", pixel_font)
	
	btn.mouse_entered.connect(func(): AudioManager.play("hover"))
	btn.pressed.connect(func(): AudioManager.play("click"))
	return btn

func _on_buy_pressed(amount: int) -> void:
	AudioManager.play("success")
	var current = AuthManager.current_user.get("avatar_credits", 0)
	AuthManager.current_user["avatar_credits"] = current + amount
	AuthManager.update_user_details({"avatar_credits": AuthManager.current_user["avatar_credits"]})
	UIUtils.show_toast("Purchased %d credits!" % amount, C_GOLD)
	get_tree().change_scene_to_file(HOME_SCENE)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(HOME_SCENE)

func _animate_in() -> void:
	modulate.a = 0.0
	var tw = create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.3)