extends Control

const LOGIN_SCENE := "res://screens/login.tscn"

var _welcome_label: Label        = null
var _logout_button: Button       = null
var _content_area: VBoxContainer = null

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.08, 0.06, 0.14)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var top_bg := PanelContainer.new()
	top_bg.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top_bg.custom_minimum_size = Vector2(0, 64)
	var top_style := StyleBoxFlat.new()
	top_style.bg_color = Color(0.12, 0.08, 0.22)
	top_bg.add_theme_stylebox_override("panel", top_style)
	add_child(top_bg)

	var top_hbox := HBoxContainer.new()
	top_hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	top_hbox.add_theme_constant_override("separation", 12)
	top_bg.add_child(top_hbox)

	var label_margin := MarginContainer.new()
	label_margin.add_theme_constant_override("margin_left", 20)
	label_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(label_margin)

	var app_title := Label.new()
	app_title.text = "🎵 Concertopia"
	app_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	app_title.add_theme_font_size_override("font_size", 22)
	app_title.add_theme_color_override("font_color", Color(1, 1, 1))
	app_title.custom_minimum_size = Vector2(0, 64)
	label_margin.add_child(app_title)

	var btn_margin := MarginContainer.new()
	btn_margin.add_theme_constant_override("margin_right", 16)
	top_hbox.add_child(btn_margin)

	_logout_button = Button.new()
	_logout_button.text = "Log Out"
	_logout_button.flat = true
	_logout_button.add_theme_color_override("font_color", Color(0.8, 0.6, 1.0))
	_logout_button.custom_minimum_size = Vector2(90, 48)
	_logout_button.pressed.connect(_on_logout)
	btn_margin.add_child(_logout_button)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.offset_top = 64
	add_child(scroll)

	_content_area = VBoxContainer.new()
	_content_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_area.add_theme_constant_override("separation", 20)
	scroll.add_child(_content_area)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 28)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_area.add_child(margin)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 20)
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(inner)

	var user: Dictionary = AuthManager.current_user
	var name_str: String = user.get("display_name", "there")

	_welcome_label = Label.new()
	_welcome_label.text = "Hey, %s! 👋" % name_str
	_welcome_label.add_theme_font_size_override("font_size", 26)
	_welcome_label.add_theme_color_override("font_color", Color(1, 1, 1))
	_welcome_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inner.add_child(_welcome_label)

	var sub := Label.new()
	sub.text = "Ready to discover live music near you?"
	sub.add_theme_color_override("font_color", Color(1, 1, 1, 0.6))
	sub.add_theme_font_size_override("font_size", 15)
	inner.add_child(sub)

	_add_section_label(inner, "🔥 Upcoming Concerts")
	var upcoming: Array[Dictionary] = [
		{ "name": "The Midnight",    "venue": "SM Mall of Asia Arena", "date": "Apr 5, 2026",  "genre": "Synthwave" },
		{ "name": "Ben&Ben",         "venue": "Araneta Coliseum",      "date": "Apr 12, 2026", "genre": "Folk Pop"  },
		{ "name": "IV of Spades",    "venue": "Kia Theater",           "date": "Apr 19, 2026", "genre": "Funk Rock" },
		{ "name": "December Avenue", "venue": "New Frontier Theater",  "date": "Apr 26, 2026", "genre": "OPM Rock"  },
	]
	for c: Dictionary in upcoming:
		inner.add_child(_make_concert_card(c))

	_add_section_label(inner, "⭐ Recommended For You")
	var recommended: Array[Dictionary] = [
		{ "name": "SB19", "venue": "Philippine Arena", "date": "May 3, 2026",  "genre": "P-Pop" },
		{ "name": "UDD",  "venue": "Ynares Center",    "date": "May 10, 2026", "genre": "Indie" },
	]
	for c: Dictionary in recommended:
		inner.add_child(_make_concert_card(c))

func _add_section_label(parent: VBoxContainer, text: String) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", Color(1, 1, 1))
	parent.add_child(lbl)

func _make_concert_card(data: Dictionary) -> PanelContainer:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.16, 0.11, 0.28)
	style.set_corner_radius_all(12)
	style.content_margin_left   = 16
	style.content_margin_right  = 16
	style.content_margin_top    = 14
	style.content_margin_bottom = 14
	card.add_theme_stylebox_override("panel", style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	card.add_child(vbox)

	var hbox := HBoxContainer.new()
	vbox.add_child(hbox)

	var name_lbl := Label.new()
	name_lbl.text = data["name"]
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(1, 1, 1))
	hbox.add_child(name_lbl)

	var genre_lbl := Label.new()
	genre_lbl.text = data["genre"]
	genre_lbl.add_theme_font_size_override("font_size", 12)
	genre_lbl.add_theme_color_override("font_color", Color(0.7, 0.5, 1.0))
	hbox.add_child(genre_lbl)

	var venue_lbl := Label.new()
	venue_lbl.text = "📍 " + data["venue"]
	venue_lbl.add_theme_font_size_override("font_size", 13)
	venue_lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.65))
	vbox.add_child(venue_lbl)

	var date_lbl := Label.new()
	date_lbl.text = "🗓  " + data["date"]
	date_lbl.add_theme_font_size_override("font_size", 13)
	date_lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.5))
	vbox.add_child(date_lbl)

	var book_btn := Button.new()
	book_btn.text = "Book Tickets"
	book_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.45, 0.2, 0.85)
	btn_style.set_corner_radius_all(8)
	btn_style.content_margin_left   = 14
	btn_style.content_margin_right  = 14
	btn_style.content_margin_top    = 6
	btn_style.content_margin_bottom = 6
	book_btn.add_theme_stylebox_override("normal", btn_style)
	book_btn.add_theme_color_override("font_color", Color(1, 1, 1))
	book_btn.add_theme_font_size_override("font_size", 13)
	vbox.add_child(book_btn)

	return card

func _on_logout() -> void:
	AuthManager.logout()
	get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)
