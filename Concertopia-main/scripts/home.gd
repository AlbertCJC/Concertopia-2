extends Control

# ── Scene constants ────────────────────────────────────────────────────────────
const LOGIN_SCENE : String = "res://screens/login.tscn"

# ── Room data ──────────────────────────────────────────────────────────────────
const ROOMS : Array[Dictionary] = [
	{
		"artist":     "BRUNO\nMARS",
		"genre":      "Pop / R&B",
		"crowd":      67,
		"door_color": Color(0.55, 0.30, 0.10),
		"bg_color1":  Color(0.55, 0.25, 0.05),
		"bg_color2":  Color(0.85, 0.45, 0.10),
		"char_color": Color(0.85, 0.65, 0.20),
		"accent":     Color(1.00, 0.65, 0.15),
	},
	{
		"artist":     "TAYLOR\nSWIFT",
		"genre":      "Pop",
		"crowd":      67,
		"door_color": Color(0.90, 0.35, 0.55),
		"bg_color1":  Color(0.55, 0.05, 0.25),
		"bg_color2":  Color(0.90, 0.30, 0.60),
		"char_color": Color(1.00, 0.80, 0.85),
		"accent":     Color(1.00, 0.55, 0.75),
	},
	{
		"artist":     "ARIANA\nGRANDE",
		"genre":      "Pop / R&B",
		"crowd":      67,
		"door_color": Color(0.55, 0.50, 0.80),
		"bg_color1":  Color(0.20, 0.05, 0.35),
		"bg_color2":  Color(0.55, 0.15, 0.75),
		"char_color": Color(0.80, 0.65, 1.00),
		"accent":     Color(0.75, 0.50, 1.00),
	},
	{
		"artist":     "CHAPPELL\nROAN",
		"genre":      "Pop",
		"crowd":      67,
		"door_color": Color(0.75, 0.38, 0.12),
		"bg_color1":  Color(0.50, 0.18, 0.04),
		"bg_color2":  Color(0.90, 0.45, 0.10),
		"char_color": Color(1.00, 0.75, 0.50),
		"accent":     Color(1.00, 0.55, 0.20),
	},
	{
		"artist":     "THE\nWEEKND",
		"genre":      "R&B",
		"crowd":      67,
		"door_color": Color(0.12, 0.12, 0.18),
		"bg_color1":  Color(0.08, 0.04, 0.20),
		"bg_color2":  Color(0.30, 0.10, 0.50),
		"char_color": Color(0.80, 0.70, 1.00),
		"accent":     Color(0.60, 0.30, 1.00),
	},
]

# ── Carousel constants ─────────────────────────────────────────────────────────
const CARD_W      : float = 280.0
const CARD_H      : float = 160.0
const CARD_RADIUS : int   = 16
const SLIDE_DUR   : float = 0.40

# ── Verified node paths (matched against live home.tscn tree) ─────────────────
const _P_BG_TINT   : String = "BgTint"
const _P_BG_TEX    : String = "BgTexture"
const _P_STAGE     : String = "MainMargin/MainVBox/CarouselStage"
const _P_CARD_ROW  : String = "MainMargin/MainVBox/CarouselStage/CardRow"
const _P_BTN_PREV  : String = "MainMargin/MainVBox/NavRow/BtnPrev"
const _P_BTN_ENTER : String = "MainMargin/MainVBox/NavRow/BtnEnter"
const _P_BTN_NEXT  : String = "MainMargin/MainVBox/NavRow/BtnNext"
const _P_BTN_BACK  : String = "TopBar/TopHBox/BtnBack"
const _P_CHAR_DISP : String = "CharOverlay/CharDisplay"
const _P_TITLE     : String = "MainMargin/MainVBox/LabelTitle"

const SLOT_NAMES : Array[String] = [
	"Slot_BrunoMars",
	"Slot_TaylorSwift",
	"Slot_ArianaGrande",
	"Slot_ChappellRoan",
	"Slot_TheWeeknd",
]

# ── State ──────────────────────────────────────────────────────────────────────
var _current_idx  : int  = 0
var _is_animating : bool = false

# ── Cached node refs ───────────────────────────────────────────────────────────
var _bg_texture   : TextureRect = null
var _bg_tint      : ColorRect   = null
var _card_row     : Control     = null
var _stage        : Control     = null
var _btn_prev     : Button      = null
var _btn_next     : Button      = null
var _btn_enter    : Button      = null
var _btn_back     : Button      = null
var _char_display : TextureRect = null

var _slot_labels : Array[Label]     = []
var _slot_crowds : Array[Label]     = []
var _slot_bgs    : Array[ColorRect] = []
var _slot_doors  : Array[Control]   = []

var _pixel_font : FontFile = null

# ── Lifecycle ──────────────────────────────────────────────────────────────────
func _ready() -> void:
	_pixel_font = load(
		"res://Pixelify_Sans/static/PixelifySans-Bold.ttf"
	) as FontFile
	_cache_nodes()
	_connect_signals()
	_bind_slot_refs()
	_apply_fonts()
	_populate_cards()
	_show_character()
	_size_slots()
	_snap_row()

func _cache_nodes() -> void:
	_bg_texture   = get_node(_P_BG_TEX)    as TextureRect
	_bg_tint      = get_node(_P_BG_TINT)   as ColorRect
	_card_row     = get_node(_P_CARD_ROW)  as Control
	_stage        = get_node(_P_STAGE)     as Control
	_btn_prev     = get_node(_P_BTN_PREV)  as Button
	_btn_next     = get_node(_P_BTN_NEXT)  as Button
	_btn_enter    = get_node(_P_BTN_ENTER) as Button
	_btn_back     = get_node(_P_BTN_BACK)  as Button
	_char_display = get_node(_P_CHAR_DISP) as TextureRect

	assert(_card_row  != null, "home.gd: CardRow not found")
	assert(_stage     != null, "home.gd: CarouselStage not found")
	assert(_btn_prev  != null, "home.gd: BtnPrev not found")
	assert(_btn_enter != null, "home.gd: BtnEnter not found")
	assert(_btn_next  != null, "home.gd: BtnNext not found")
	assert(_btn_back  != null, "home.gd: BtnBack not found")

func _connect_signals() -> void:
	_btn_prev.pressed.connect(_go_prev)
	_btn_next.pressed.connect(_go_next)
	_btn_enter.pressed.connect(_on_enter_pressed)
	_btn_back.pressed.connect(_on_logout)

func _bind_slot_refs() -> void:
	for slot_name : String in SLOT_NAMES:
		var base  : String = _P_CARD_ROW + "/" + slot_name
		var right : String = base + "/Card/CardHBox/RightArea"
		var artist_lbl : Label = get_node(
			right + "/LabelArtist"
		) as Label
		var crowd_lbl : Label = get_node(
			right + "/CrowdBadge/BadgeHBox/LabelCrowd"
		) as Label
		var bokeh : ColorRect = get_node(
			right + "/BokehBg"
		) as ColorRect
		var door : Control = get_node(
			base + "/Card/CardHBox/DoorPanel"
		) as Control
		_slot_labels.append(artist_lbl)
		_slot_crowds.append(crowd_lbl)
		_slot_bgs.append(bokeh)
		_slot_doors.append(door)

func _apply_fonts() -> void:
	if _pixel_font == null:
		return
	for lbl : Label in _slot_labels:
		lbl.add_theme_font_override("font", _pixel_font)
	for lbl : Label in _slot_crowds:
		lbl.add_theme_font_override("font", _pixel_font)
	_btn_prev.add_theme_font_override("font", _pixel_font)
	_btn_next.add_theme_font_override("font", _pixel_font)
	_btn_enter.add_theme_font_override("font", _pixel_font)
	_btn_back.add_theme_font_override("font", _pixel_font)
	var title : Label = get_node(_P_TITLE) as Label
	if title:
		title.add_theme_font_override("font", _pixel_font)

func _populate_cards() -> void:
	for i : int in ROOMS.size():
		var data : Dictionary = ROOMS[i]
		_slot_labels[i].text = data["artist"]
		_slot_crowds[i].text = str(data["crowd"])
		_slot_bgs[i].color   = data["bg_color1"]
		_style_door(_slot_doors[i], data["door_color"])
		_style_card_panel(i, data["bg_color1"])

func _style_card_panel(idx : int, bg : Color) -> void:
	var card_path : String = (
		_P_CARD_ROW + "/" + SLOT_NAMES[idx] + "/Card"
	)
	var card : PanelContainer = get_node(card_path) as PanelContainer
	if card == null:
		return
	var style : StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = bg
	style.set_corner_radius_all(CARD_RADIUS)
	card.add_theme_stylebox_override("panel", style)

func _style_door(door : Control, col : Color) -> void:
	if door == null:
		return
	for c : Node in door.get_children():
		c.queue_free()

	var door_bg : ColorRect = ColorRect.new()
	door_bg.color = col.darkened(0.3)
	door_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	door_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	door.add_child(door_bg)

	var frame : ColorRect = ColorRect.new()
	frame.color = col.lightened(0.15)
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left   = 8.0
	frame.offset_right  = -8.0
	frame.offset_top    = 12.0
	frame.offset_bottom = -8.0
	frame.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	door.add_child(frame)

	var door_fill : ColorRect = ColorRect.new()
	door_fill.color = col
	door_fill.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	door_fill.offset_left   = 12.0
	door_fill.offset_right  = -12.0
	door_fill.offset_top    = 16.0
	door_fill.offset_bottom = -12.0
	door_fill.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	door.add_child(door_fill)

	for i : int in 3:
		var stripe : ColorRect = ColorRect.new()
		stripe.color = col.darkened(0.25)
		stripe.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var y_off : float = 22.0 + float(i) * 28.0
		stripe.offset_left   = 14.0
		stripe.offset_right  = -14.0
		stripe.offset_top    = y_off
		stripe.offset_bottom = y_off + 18.0
		stripe.mouse_filter  = Control.MOUSE_FILTER_IGNORE
		door.add_child(stripe)

	var knob : ColorRect = ColorRect.new()
	knob.color = Color(1.0, 0.85, 0.3)
	knob.custom_minimum_size = Vector2(6.0, 6.0)
	knob.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT)
	knob.offset_right  = -17.0
	knob.offset_left   = -23.0
	knob.offset_top    = 4.0
	knob.offset_bottom = 10.0
	knob.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	door.add_child(knob)

func _show_character() -> void:
	if _char_display == null:
		return
	var skin_path : String = AuthManager.current_user.get(
		"character_skin", ""
	)
	if skin_path.is_empty():
		_char_display.visible = false
		return
	var tex : Texture2D = load(skin_path) as Texture2D
	if tex == null:
		_char_display.visible = false
		return
	var atlas : AtlasTexture = AtlasTexture.new()
	atlas.atlas  = tex
	atlas.region = Rect2(0.0, 0.0, 237.0, 351.0)
	_char_display.texture = atlas
	_char_display.visible = true

func _size_slots() -> void:
	if _stage == null or _card_row == null:
		return
	var vp_w : float = get_viewport().get_visible_rect().size.x
	var vp_h : float = _stage.size.y
	for i : int in SLOT_NAMES.size():
		var slot_path : String = _P_CARD_ROW + "/" + SLOT_NAMES[i]
		var slot : Control = get_node(slot_path) as Control
		if slot == null:
			continue
		slot.position = Vector2(float(i) * vp_w, 0.0)
		slot.size     = Vector2(vp_w, vp_h)
		var card : PanelContainer = get_node(
			slot_path + "/Card"
		) as PanelContainer
		if card == null:
			continue
		card.position = Vector2(
			(vp_w - CARD_W) / 2.0,
			(vp_h - CARD_H) / 2.0
		)
	_card_row.size = Vector2(
		float(SLOT_NAMES.size()) * vp_w, vp_h
	)

func _notification(what : int) -> void:
	if what == NOTIFICATION_RESIZED:
		_size_slots()
		_snap_row()

func _go_prev() -> void:
	_navigate(-1)

func _go_next() -> void:
	_navigate(1)

func _navigate(dir : int) -> void:
	if _is_animating:
		return
	var next : int = _current_idx + dir
	if next < 0 or next >= ROOMS.size():
		_bounce_card(dir)
		return
	_current_idx  = next
	_is_animating = true
	_slide_row()

func _snap_row() -> void:
	if _card_row == null:
		return
	_card_row.position.x = _row_target_x()

func _slide_row() -> void:
	var target_x : float = _row_target_x()
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(_card_row, "position:x", target_x, SLIDE_DUR)
	t.finished.connect(func() -> void: _is_animating = false)

func _row_target_x() -> float:
	var vp_w : float = get_viewport().get_visible_rect().size.x
	return -float(_current_idx) * vp_w

func _bounce_card(dir : int) -> void:
	var t : Tween = create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_BACK)
	var nudge : float = float(dir) * -18.0
	var base  : float = _row_target_x()
	t.tween_property(_card_row, "position:x", base + nudge, 0.12)
	t.tween_property(_card_row, "position:x", base, 0.18)

var _swipe_start_x    : float = 0.0
var _swipe_active     : bool  = false
const SWIPE_THRESHOLD : float = 40.0

func _input(event : InputEvent) -> void:
	if event is InputEventScreenTouch:
		var e : InputEventScreenTouch = event as InputEventScreenTouch
		if e.pressed:
			_swipe_start_x = e.position.x
			_swipe_active  = true
		else:
			_swipe_active = false
	elif event is InputEventScreenDrag:
		if not _swipe_active:
			return
		var e : InputEventScreenDrag = event as InputEventScreenDrag
		var delta : float = e.position.x - _swipe_start_x
		if absf(delta) > SWIPE_THRESHOLD:
			_swipe_active = false
			if delta < 0.0:
				_go_next()
			else:
				_go_prev()

func _on_enter_pressed() -> void:
	var room : Dictionary = ROOMS[_current_idx]
	print("Entering: ", room["artist"])
	# TODO: navigate to concert room scene

func _on_logout() -> void:
	AuthManager.logout()
	get_tree().change_scene_to_file.call_deferred(LOGIN_SCENE)
