extends Control

# ── Scene constants ────────────────────────────────────────────────────────────
const HOME_SCENE : String = "res://screens/home.tscn"

# ── Color palette ──────────────────────────────────────────────────────────────
const C_BG         : Color = Color(0.06, 0.04, 0.14)
const C_PANEL      : Color = Color(0.12, 0.08, 0.24)
const C_PANEL_DARK : Color = Color(0.04, 0.03, 0.10)
const C_GOLD       : Color = Color(0.78, 0.59, 0.35)
const C_GOLD_LIGHT : Color = Color(0.92, 0.75, 0.48)
const C_CREAM      : Color = Color(0.96, 0.91, 0.78)
const C_MUTED      : Color = Color(0.55, 0.55, 0.65)
const C_PINK       : Color = Color(0.96, 0.42, 0.62)

# ── Artist journey data ────────────────────────────────────────────────────────
# Each entry: { "year": String, "title": String, "text": String }
const JOURNEYS : Dictionary = {
	"BRUNO\nMARS": [
		{
			"year": "1985",
			"title": "Born in Honolulu",
			"text": "Peter Gene Hernandez is born on October 8 in Honolulu, Hawaii, into a deeply musical family. His father plays Latin percussion and his mother is a talented singer and hula dancer. He grows up performing Elvis Presley impersonations in his family's show act, Little Elvis, at just four years old — catching early local fame and a cameo in the film Honeymoon in Vegas."
		},
		{
			"year": "2004",
			"title": "Moving to Los Angeles",
			"text": "At 17, Bruno moves to Los Angeles with dreams of a record deal. The early years are brutally difficult — he is dropped by Motown Records before releasing a single note. He spends years writing songs for other artists, honing a voice and pen that would soon reshape pop music. He writes for artists like Brandy, Matisyahu, and Adam Levine, living on small co-writing fees."
		},
		{
			"year": "2009",
			"title": "Breakthrough as a Writer",
			"text": "Bruno co-writes Nothin' on You for B.o.B and Billionaire for Travie McCoy, both global hits that crack the Billboard Hot 100's top five. The songs showcase his knack for effortlessly melodic hooks. The world begins to wonder: who is the voice singing those unforgettable choruses? His name starts circulating among industry insiders as a songwriter to watch."
		},
		{
			"year": "2010",
			"title": "Just the Way You Are",
			"text": "His debut single Just the Way You Are is released under Elektra Records and reaches number one in the United States, United Kingdom, and Australia. The song is disarmingly tender — a direct love letter that strips away pop artifice. It earns him a Grammy for Best Male Pop Vocal Performance and announces him not just as a hitmaker for others, but as a solo force of nature."
		},
		{
			"year": "2012",
			"title": "Unorthodox Jukebox Era",
			"text": "Unorthodox Jukebox confirms he is not a one-trick artist. The album blends funk, reggae, soul, and rock across Locked Out of Heaven, When I Was Your Man, and Gorilla. It debuts at number two on the Billboard 200 and wins the Grammy for Best Pop Vocal Album. Critics praise his fearless genre-hopping as a love letter to decades of American music."
		},
		{
			"year": "2014",
			"title": "Super Bowl XLVIII Halftime Show",
			"text": "Bruno performs at the Super Bowl halftime show in New Jersey — the first artist to headline the show solo in years. The performance is electric: spinning, sliding, and commanding a stadium of 80,000 with nothing but his voice and a tight band. Viewing figures exceed 115 million in the United States alone. It cements his status as one of the greatest live performers of his generation."
		},
		{
			"year": "2016",
			"title": "24K Magic",
			"text": "24K Magic is a love letter to 1980s and 1990s R&B and funk — a deliberate, joyful throwback soaked in New Jack Swing, Minneapolis Sound, and Miami bass. The album sweeps the 2018 Grammys, winning all six categories it was nominated in, including Album of the Year and Record of the Year. Bruno becomes only the second artist in Grammy history to win Album of the Year twice as a primary artist."
		},
		{
			"year": "2021–Now",
			"title": "Silk Sonic & Beyond",
			"text": "Teaming with Anderson .Paak as Silk Sonic, Bruno releases An Evening with Silk Sonic — a lush, Seventies-soul concept project that wins four Grammys in 2022. Leave the Door Open becomes a cultural phenomenon. His Las Vegas residency at Park MGM draws the highest per-show grosses in the city's history. He remains one of the most streamed artists alive, with over 10 billion streams and counting."
		},
	],
	"TAYLOR\nSWIFT": [
		{
			"year": "1989",
			"title": "Born in West Reading",
			"text": "Taylor Alison Swift is born on December 13 in West Reading, Pennsylvania, to a financial advisor father and a homemaker mother who had been a marketing executive. From childhood she immerses herself in musical theatre, studying voice and dance in New York City. At eleven, her family moves to Hendersonville, Tennessee, so she can pursue a country music career — a bold bet that would reshape the entire genre."
		},
		{
			"year": "2004",
			"title": "Signing with Big Machine",
			"text": "At fourteen, Taylor becomes the youngest artist ever signed to Sony/ATV Music Publishing. She then signs with Big Machine Records, a then-fledgling Nashville label. She is handed creative control — an almost unheard-of arrangement for a teenager — and she uses it fiercely, co-writing every song on her debut. The industry is already watching her with a mix of fascination and doubt."
		},
		{
			"year": "2006",
			"title": "Self-Titled Debut",
			"text": "Taylor Swift, her debut album, is released at age sixteen and signals something genuinely new in country music: a teenage girl writing her own diary-entry songs with cinematic clarity. Tim McGraw and Teardrops on My Guitar become radio staples. The album spends over two years on the Billboard 200 and produces four country top-40 singles. She wins the Country Music Association Award for Horizon Award — the beginning of an unbroken awards streak."
		},
		{
			"year": "2008",
			"title": "Fearless and Global Stardom",
			"text": "Fearless shatters genre walls, becoming the best-selling album of 2009 in the United States across all genres. Love Story rewrites country-pop crossover records, and You Belong with Me dominates both charts simultaneously. At twenty, she wins the Grammy for Album of the Year, becoming the youngest artist to do so at that time. The world stops debating whether she was a novelty: Taylor Swift is generational."
		},
		{
			"year": "2012",
			"title": "Red and the Pivot to Pop",
			"text": "Red is the first album where Taylor begins stretching toward pure pop, blending country heartbreak with synth-driven production on We Are Never Ever Getting Back Together and I Knew You Were Trouble. The album sells over one million copies in its first week. Years later, re-recorded as Red (Taylor's Version) in 2021, it charts anew and restores the cultural conversation about who owns an artist's legacy."
		},
		{
			"year": "2014",
			"title": "1989 — Full Pop Arrival",
			"text": "1989 is a declaration: Taylor Swift is a pop star now, full stop. Produced with Max Martin and Shellback, the album opens with Shake It Off and Blank Space — two number-one singles that define the mid-2010s cultural landscape. She pulls her entire catalog from Spotify, a move that sends shockwaves through the streaming industry. The album wins Album of the Year at the Grammys, making her the first woman to win the award twice."
		},
		{
			"year": "2019–2023",
			"title": "The Re-Recording Era",
			"text": "After a public dispute over the ownership of her Big Machine masters, Taylor launches the Taylor's Version project — re-recording her first six albums to reclaim her work. The project is unprecedented: each re-release tops charts and sparks cultural dialogue about artist rights. Midnights (2023) breaks Spotify's single-day streaming record and the Eras Tour becomes the first concert tour to gross over one billion dollars."
		},
		{
			"year": "2024–Now",
			"title": "A Cultural Institution",
			"text": "TIME magazine names her Person of the Year for 2023. The Eras Tour grosses over two billion dollars and is credited with measurable economic impact in every city it visits. She holds the record for the most Grammy wins by any artist in history. Taylor Swift is no longer just a musician — she is a lens through which a generation processes heartbreak, joy, and identity."
		},
	],
	"ARIANA\nGRANDE": [
		{
			"year": "1993",
			"title": "Born in Boca Raton",
			"text": "Ariana Grande-Butera is born on June 26 in Boca Raton, Florida, to a graphic design company owner and a CEO of telephone communications. She begins performing in community theatre at age eight, appearing in productions of Annie and The Wizard of Oz. Her vocal gift is evident from childhood — a four-octave range that her instructors note is almost preternaturally mature for her age."
		},
		{
			"year": "2009",
			"title": "Broadway and Victorious",
			"text": "At fifteen, Ariana makes her Broadway debut in 13, a musical specifically written for a teenage cast. Her performance earns her a National Youth Theatre Association Award. The following year she lands the role of Cat Valentine on Nickelodeon's Victorious — a bubbly, comedically innocent character that her legions of young fans would adore, even as the singer's voice hinted at something far deeper."
		},
		{
			"year": "2013",
			"title": "Yours Truly — The Debut",
			"text": "Yours Truly debuts at number one on the Billboard 200. The album is soaked in early-1990s R&B nostalgia, and critics immediately compare her voice to Mariah Carey's — an enormous compliment and expectation she would spend years working to outrun. The Problem featuring Iggy Azalea follows in 2014 and becomes a defining pop record, confirming she was not simply a nostalgia act."
		},
		{
			"year": "2014–2016",
			"title": "My Everything & Dangerous Woman",
			"text": "My Everything and Dangerous Woman establish Ariana as a commercial juggernaut. Dangerous Woman in particular is a mature reinvention — softer in palette but more assertive in identity — and her refusal to be pigeon-holed into bubbly pop endears her to fans who had grown alongside her. She headlines the Billboard Music Awards and sells out arenas worldwide."
		},
		{
			"year": "2017",
			"title": "Manchester and One Love",
			"text": "On May 22, a terrorist bombing at her Manchester Arena concert kills 22 people and injures hundreds more. The tragedy shakes the global music community. Within two weeks, Ariana organises One Love Manchester — a benefit concert that raises over 23 million pounds for victims' families. She returns to Manchester, kneels with survivors, and sings. The world watches in tears. It is one of the most courageous acts in modern music history."
		},
		{
			"year": "2018",
			"title": "Sweetener and Thank U, Next",
			"text": "Sweetener wins the Grammy for Best Pop Vocal Album and is universally praised for its emotional maturity. Then, just five months later, Thank U, Next arrives — an album written and recorded in the aftermath of profound personal loss. The title track, released after the death of her ex-partner Mac Miller, is a meditation on gratitude rather than bitterness. It becomes one of the most-streamed songs in history."
		},
		{
			"year": "2019–Now",
			"title": "7 Rings and Cultural Dominance",
			"text": "7 Rings debuts at number one and holds the spot for eight weeks. Ariana becomes the first artist to hold the top three spots on the Billboard Hot 100 simultaneously. She headlines Coachella as the youngest solo headliner in the festival's history. Her Positions album and subsequent Eternal Sunshine continue to evolve her artistry. She remains among the most-streamed artists alive, with her influence stretching across pop, R&B, and musical theatre."
		},
	],
	"CHAPPELL\nROAN": [
		{
			"year": "1998",
			"title": "Born in Willard, Missouri",
			"text": "Kayleigh Rose Amstutz is born on February 19 in Willard, Missouri — a small Ozark town of around 5,000 people. She grows up in a conservative Christian household, attending church regularly, and begins singing in the church choir. From early childhood she is drawn to theatrical, expressive music — qualities that would eventually become her defining artistic signature."
		},
		{
			"year": "2017",
			"title": "Signing and the Chappell Roan Name",
			"text": "At seventeen, she is discovered by Dan Nigro, a producer who would become her key collaborator. She signs with Atlantic Records and adopts the stage name Chappell Roan, after an old country song she finds on one of her grandfather's records. The name carries the weight of nostalgia and reinvention — two ideas that would come to define her entire creative project."
		},
		{
			"year": "2020",
			"title": "School Nights EP and Release",
			"text": "Her School Nights EP is released to quiet reception. Atlantic Records drops her shortly after, leaving her without a label for the better part of two years. Rather than retreat, she continues writing and performing, living with her parents in Missouri and returning to local jobs. The period, though grinding, deepens her songwriting and sharpens the maximalist pop-theatrics that would eventually ignite the world."
		},
		{
			"year": "2023",
			"title": "The Rise of the Pink Pony Club",
			"text": "Signed to Island Records and working again with Dan Nigro, Chappell begins releasing singles from her forthcoming debut album. Good Luck, Babe! and Red Wine Supernova build a cult following online — predominantly among LGBTQ+ audiences who find her drag-inspired visual world and unabashedly queer storytelling validating and electrifying. TikTok accelerates her reach beyond any traditional marketing campaign."
		},
		{
			"year": "2024",
			"title": "The Rise and Rise",
			"text": "Her debut album The Rise and Fall of a Midwest Princess is officially released in 2023 to critical ecstasy, but it is throughout 2024 that it becomes a mainstream phenomenon. She performs sold-out shows across North America and Europe, her theatrical live shows — involving elaborate costume changes, lipstick-smeared backup dancers, and stadium-sized camp — earning comparisons to Kate Bush and Lady Gaga in the same breath."
		},
		{
			"year": "2024",
			"title": "Grammy Win and Mainstream Breakthrough",
			"text": "Chappell Roan wins Best New Artist at the 2025 Grammy Awards, delivering a speech in which she openly criticises the music industry's treatment of artists. The moment ricochets across social media and news cycles for days. Good Luck, Babe! is certified multi-platinum in over a dozen countries. She is the rare slow-burn success story: an artist who spent six years in relative obscurity before becoming inescapable."
		},
		{
			"year": "Now",
			"title": "A New Kind of Pop Star",
			"text": "Chappell Roan represents something the mainstream pop landscape had been missing: a maximalist queer theatricality rooted in Midwest sincerity. She is not curated for algorithmic palatability. Her live shows are events — costumed, choreographed, emotionally generous. Her journey from a Missouri church choir to Grammy winner is one of the great origin stories in modern pop music."
		},
	],
	"THE\nWEEKND": [
		{
			"year": "1990",
			"title": "Born in Toronto",
			"text": "Abel Makkonen Tesfaye is born on February 16 in Toronto, Ontario, to Ethiopian immigrant parents. His parents separate when he is a toddler and he is raised primarily by his grandmother, speaking Amharic as his first language. He grows up in Scarborough — a diverse, working-class suburb east of Toronto — listening obsessively to Michael Jackson, Prince, and R&B on late-night radio, dreaming of a world far larger than his surroundings."
		},
		{
			"year": "2010",
			"title": "Anonymous Mixtape Trilogy",
			"text": "At nineteen, Abel uploads three songs to YouTube under the anonymous name The Weeknd — a deliberate misspelling to avoid a Canadian band's trademark. The Trilogy mixtapes (House of Balloons, Thursday, and Echoes of Silence) are released for free and spread virally through music blogs. Their sound — smeared, gothic R&B draped in the haze of Drake-era Toronto — is unlike anything else in contemporary music. Nobody knows his face. The mystery amplifies the obsession."
		},
		{
			"year": "2013",
			"title": "Kiss Land and the Industry",
			"text": "Kiss Land, his debut studio album, is released through Republic Records and lands at number two on the Billboard 200. The album is dark, cinematic, and deliberately inaccessible — a refusal of the radio-friendly format that industry executives had been hoping for. Critics call it 'too long, too bleak' while simultaneously calling it a masterpiece. Abel does not compromise. He is building something for the long term."
		},
		{
			"year": "2015",
			"title": "Beauty Behind the Madness",
			"text": "Beauty Behind the Madness is the album that cracks open the mainstream. Can't Feel My Face reaches number one worldwide. Earned It wins the Grammy for Best R&B Performance after its placement in Fifty Shades of Grey. The Weeknd performs at the Super Bowl press conference and appears on the cover of Rolling Stone. He is no longer anonymous. He is a global pop star — and he carries his darkness with him anyway."
		},
		{
			"year": "2016",
			"title": "Starboy",
			"text": "Starboy, produced in collaboration with Daft Punk, is a sonic leap — cleaner, more electronic, but still soaked in nocturnal dread. The title track reaches number one in over twenty countries. I Feel It Coming and Secrets demonstrate a more optimistic, disco-inflected side, and the album cements his reputation as an artist who refuses to be contained by genre. He wins the Grammy for Best Urban Contemporary Album."
		},
		{
			"year": "2020",
			"title": "After Hours and Blinding Lights",
			"text": "After Hours produces Blinding Lights — a song that becomes the most-charted song in Billboard Hot 100 history. It spends 57 weeks in the top 10, a record. The accompanying visual world — inspired by 1980s synthwave and neon-soaked noir — is coherent and haunting. His Super Bowl LV halftime performance in 2021 features mirror-masked dancers in a disorienting labyrinth. It is widely considered one of the greatest halftime shows ever staged."
		},
		{
			"year": "2022–Now",
			"title": "Dawn FM and the Final Chapter",
			"text": "Dawn FM is presented as the penultimate album in a trilogy that began with After Hours. Conceptually rich and emotionally sophisticated, it features Jim Carrey as a narrator guiding listeners through a purgatorial radio station. Its follow-up, The Idol (HBO series) expands his creative ambitions to television. He announces that his next album will be his final work as The Weeknd before a new artistic identity emerges. The entire music world waits."
		},
	],
}

# ── Concert tour data ──────────────────────────────────────────────────────────
const CONCERT_TOURS : Dictionary = {
	"BRUNO\nMARS": [
		{ "year": "2010–2012", "title": "The Doo-Wops & Hooligans Tour", "text": "Bruno Mars' debut headlining tour to support his breakthrough album.", "youtube_id": "LjhCEhWiKXk" },
		{ "year": "2013–2014", "title": "The Moonshine Jungle Tour", "text": "A massive global tour supporting Unorthodox Jukebox.", "youtube_id": "nPvuNsRccVw" },
		{ "year": "2017–2018", "title": "24K Magic World Tour", "text": "An incredibly successful tour celebrating 1990s R&B and funk.", "youtube_id": "UqyT8IEBkvY" },
		{ "year": "2021–Now", "title": "Silk Sonic & Las Vegas Residency", "text": "Performances focusing on his collaborative project with Anderson .Paak.", "youtube_id": "adLGHcj_fmA" }
	],
	"TAYLOR\nSWIFT": [
		{ "year": "2009–2010", "title": "Fearless Tour", "text": "Taylor's debut headlining concert tour.", "youtube_id": "8xg3vE8Ie_E" },
		{ "year": "2011–2012", "title": "Speak Now World Tour", "text": "A highly theatrical tour where Swift acted as the sole writer of the album.", "youtube_id": "Jb2stN7kH28" },
		{ "year": "2013–2014", "title": "The Red Tour", "text": "Her transitional tour bridging country and pure pop.", "youtube_id": "vNoKguSdy4Y" },
		{ "year": "2015", "title": "The 1989 World Tour", "text": "A massive pop spectacle filled with surprise guest appearances.", "youtube_id": "nfWlot6h_JM" },
		{ "year": "2018", "title": "Reputation Stadium Tour", "text": "A darker, more intense stadium-only tour featuring giant inflatable snakes.", "youtube_id": "3tmd-ClpJxA" },
		{ "year": "2023–2024", "title": "The Eras Tour", "text": "A monumental, career-spanning retrospective.", "youtube_id": "ic8j13piAhQ" }
	],
	"ARIANA\nGRANDE": [
		{ "year": "2013", "title": "The Listening Sessions", "text": "Ariana's debut tour supporting Yours Truly.", "youtube_id": "_sV0S8qWSy0" },
		{ "year": "2015", "title": "The Honeymoon Tour", "text": "Her first global arena tour supporting My Everything.", "youtube_id": "iS1g8G_njx8" },
		{ "year": "2017", "title": "Dangerous Woman Tour", "text": "A more mature and globally expansive tour.", "youtube_id": "1ekZEVeXwek" },
		{ "year": "2019", "title": "Sweetener World Tour", "text": "Supporting both Sweetener and Thank U, Next.", "youtube_id": "ffxKSjUwKdU" }
	],
	"CHAPPELL\nROAN": [
		{ "year": "2023", "title": "The Naked in North America Tour", "text": "Her first headlining tour, playing small clubs.", "youtube_id": "jv4P2Jaf_r0" },
		{ "year": "2024", "title": "The Midwest Princess Tour", "text": "A massive breakout tour following her sudden mainstream explosion.", "youtube_id": "h_V2o_lI-A8" },
		{ "year": "2024–Now", "title": "Festival Domination", "text": "Historic, record-breaking crowds at major festivals.", "youtube_id": "P0U_S_v_v_Y" }
	],
	"THE\nWEEKND": [
		{ "year": "2012", "title": "The Fall Tour", "text": "His first tour supporting the Trilogy mixtapes.", "youtube_id": "O1OTWCd40vU" },
		{ "year": "2014", "title": "King of the Fall Tour", "text": "A short but significant tour transitioning him to a mainstream force.", "youtube_id": "JPIhUaONiLU" },
		{ "year": "2015", "title": "The Madness Fall Tour", "text": "Supporting Beauty Behind the Madness.", "youtube_id": "KEI4qSrkPAs" },
		{ "year": "2017", "title": "Starboy: Legend of the Fall Tour", "text": "A colossal world tour featuring a massive spaceship lighting rig.", "youtube_id": "34Na4j8HLjc" },
		{ "year": "2022–2024", "title": "After Hours til Dawn Stadium Tour", "text": "A visually stunning, post-apocalyptic stadium tour.", "youtube_id": "4NRXx6U8ABQ" }
	]
}

# ── Room data ──────────────────────────────────────────────────────────────────
var _room : Dictionary = {}

# ── Fonts ──────────────────────────────────────────────────────────────────────
var _pixel_font : FontFile = null
var _body_font  : FontFile = null

# ── Cinema Popup UI ────────────────────────────────────────────────────────────
var _cinema_layer   : CanvasLayer = null
var _cinema_overlay : ColorRect = null
var _cinema_panel   : PanelContainer = null
var _cinema_thumb   : TextureRect = null
var _cinema_title   : Label = null
var _cinema_desc    : Label = null
var _cinema_watch_btn : Button = null
var _cinema_close_btn : Button = null
var _cinema_active_id : String = ""

func _build_cinema_ui() -> void:
	var acc : Color = _room.get("accent", C_PINK)
	
	_cinema_layer = CanvasLayer.new()
	_cinema_layer.layer = 100 # High layer
	add_child(_cinema_layer)
	
	_cinema_overlay = ColorRect.new()
	_cinema_overlay.color = Color(0, 0, 0, 0.85)
	_cinema_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cinema_overlay.visible = false
	_cinema_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_cinema_layer.add_child(_cinema_overlay)
	
	# CenterContainer ensures perfect centering on any screen resolution
	var center_container := CenterContainer.new()
	center_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_cinema_overlay.add_child(center_container)
	
	_cinema_panel = PanelContainer.new()
	_cinema_panel.custom_minimum_size = Vector2(600, 450)
	var style := StyleBoxFlat.new()
	style.bg_color = C_PANEL_DARK
	style.border_width_left = 4; style.border_width_right = 4
	style.border_width_top = 4; style.border_width_bottom = 4
	style.border_color = acc
	style.set_corner_radius_all(0)
	style.shadow_color = Color(0, 0, 0, 0.8)
	style.shadow_size = 30
	_cinema_panel.add_theme_stylebox_override("panel", style)
	center_container.add_child(_cinema_panel)
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	_cinema_panel.add_child(margin)
	
	var inner_vbox := VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", 15)
	margin.add_child(inner_vbox)
	
	_cinema_thumb = TextureRect.new()
	_cinema_thumb.custom_minimum_size = Vector2(560, 315) # 16:9
	_cinema_thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_cinema_thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_cinema_thumb.texture = load("res://icons/loading.svg")
	inner_vbox.add_child(_cinema_thumb)
	
	_cinema_title = Label.new()
	_cinema_title.text = "TOUR TITLE"
	_cinema_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cinema_title.add_theme_color_override("font_color", C_GOLD_LIGHT)
	_cinema_title.add_theme_font_size_override("font_size", 20)
	if _pixel_font: _cinema_title.add_theme_font_override("font", _pixel_font)
	inner_vbox.add_child(_cinema_title)
	
	_cinema_desc = Label.new()
	_cinema_desc.text = "Tour details go here..."
	_cinema_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cinema_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_cinema_desc.add_theme_color_override("font_color", C_CREAM)
	_cinema_desc.add_theme_font_size_override("font_size", 12)
	if _body_font: _cinema_desc.add_theme_font_override("font", _body_font)
	inner_vbox.add_child(_cinema_desc)
	
	var btn_hbox := HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 20)
	inner_vbox.add_child(btn_hbox)
	
	_cinema_watch_btn = Button.new()
	_cinema_watch_btn.text = "WATCH IN THEATRE"
	_cinema_watch_btn.custom_minimum_size = Vector2(200, 45)
	var wn := _flat(acc, 0); var wh := _flat(acc.lightened(0.2), 0)
	_cinema_watch_btn.add_theme_stylebox_override("normal", wn)
	_cinema_watch_btn.add_theme_stylebox_override("hover", wh)
	_cinema_watch_btn.add_theme_color_override("font_color", C_PANEL_DARK)
	if _pixel_font: _cinema_watch_btn.add_theme_font_override("font", _pixel_font)
	_cinema_watch_btn.pressed.connect(_on_watch_in_theatre_pressed)
	btn_hbox.add_child(_cinema_watch_btn)
	
	_cinema_close_btn = Button.new()
	_cinema_close_btn.text = "CLOSE"
	_cinema_close_btn.custom_minimum_size = Vector2(120, 45)
	var cn := _flat(C_MUTED, 0); var ch := _flat(C_MUTED.lightened(0.2), 0)
	_cinema_close_btn.add_theme_stylebox_override("normal", cn)
	_cinema_close_btn.add_theme_stylebox_override("hover", ch)
	if _pixel_font: _cinema_close_btn.add_theme_font_override("font", _pixel_font)
	_cinema_close_btn.pressed.connect(_hide_cinema)
	btn_hbox.add_child(_cinema_close_btn)

func _show_cinema(entry: Dictionary) -> void:
	_cinema_active_id = entry.get("youtube_id", "")
	_cinema_title.text = entry.get("title", "").to_upper()
	_cinema_desc.text = entry.get("text", "")
	
	if _cinema_overlay == null:
		return
		
	_cinema_overlay.visible = true
	_cinema_overlay.modulate.a = 0.0
	
	var tw := create_tween()
	tw.tween_property(_cinema_overlay, "modulate:a", 1.0, 0.2)

	if not _cinema_active_id.is_empty():
		_fetch_thumbnail(_cinema_active_id, "maxresdefault")

func _fetch_thumbnail(id: String, quality: String) -> void:
	UIUtils.add_shimmer(_cinema_thumb)
	var url = "https://img.youtube.com/vi/%s/%s.jpg" % [id, quality]
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(func(res, code, hdrs, body):
		UIUtils.remove_shimmer(_cinema_thumb)
		if code == 200:
			var img = Image.new()
			if img.load_jpg_from_buffer(body) == OK:
				_cinema_thumb.texture = ImageTexture.create_from_image(img)
		elif quality == "maxresdefault":
			_fetch_thumbnail(id, "hqdefault")
		http.queue_free()
	)
	http.request(url)

func _hide_cinema() -> void:
	var tw := create_tween()
	tw.tween_property(_cinema_overlay, "modulate:a", 0.0, 0.2)
	tw.chain().tween_callback(func(): _cinema_overlay.visible = false)

# ── AI Artist Chat ────────────────────────────────────────────────────────────
var _chat_panel   : PanelContainer = null
var _chat_log     : RichTextLabel = null
var _chat_input   : LineEdit      = null
var _chat_open    : bool = false
var _chat_loading : bool = false
var _chat_toggle_btn : Button = null
var _chat_http    : HTTPRequest = null

func _build_chat_ui() -> void:
	var acc : Color = _room.get("accent", C_PINK)
	
	_chat_http = HTTPRequest.new()
	add_child(_chat_http)
	_chat_http.request_completed.connect(_on_chat_request_completed)
	
	# 1. Floating Toggle Button
	_chat_toggle_btn = Button.new()
	_chat_toggle_btn.text = "💬 CHAT WITH ARTIST"
	_chat_toggle_btn.anchor_left = 0.0; _chat_toggle_btn.anchor_top = 1.0
	_chat_toggle_btn.anchor_right = 0.0; _chat_toggle_btn.anchor_bottom = 1.0
	_chat_toggle_btn.offset_left = 30; _chat_toggle_btn.offset_top = -60
	_chat_toggle_btn.offset_right = 220; _chat_toggle_btn.offset_bottom = -20
	_chat_toggle_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var style := _flat(C_PANEL, 20)
	style.border_width_left = 2; style.border_width_right = 2
	style.border_width_top = 2; style.border_width_bottom = 2
	style.border_color = acc
	_chat_toggle_btn.add_theme_stylebox_override("normal", style)
	_chat_toggle_btn.add_theme_stylebox_override("hover", _flat(acc, 20))
	_chat_toggle_btn.add_theme_color_override("font_color", Color.WHITE)
	_chat_toggle_btn.add_theme_color_override("font_hover_color", C_PANEL_DARK)
	if _pixel_font: _chat_toggle_btn.add_theme_font_override("font", _pixel_font)
	_chat_toggle_btn.pressed.connect(_toggle_chat)
	add_child(_chat_toggle_btn)
	
	# 2. Chat Panel
	_chat_panel = PanelContainer.new()
	_chat_panel.anchor_left = 0.0; _chat_panel.anchor_top = 1.0
	_chat_panel.anchor_right = 0.0; _chat_panel.anchor_bottom = 1.0
	_chat_panel.offset_left = 30; _chat_panel.offset_top = -500
	_chat_panel.offset_right = 400; _chat_panel.offset_bottom = -70
	_chat_panel.visible = false
	
	var p_style := _flat(C_PANEL_DARK, 15)
	p_style.border_width_left = 3; p_style.border_color = acc
	p_style.shadow_color = Color(0,0,0,0.6); p_style.shadow_size = 20
	_chat_panel.add_theme_stylebox_override("panel", p_style)
	add_child(_chat_panel)
	
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	_chat_panel.add_child(vbox)
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 15); margin.add_theme_constant_override("margin_right", 15)
	margin.add_theme_constant_override("margin_top", 15); margin.add_theme_constant_override("margin_bottom", 15)
	margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(margin)
	
	var inner_vbox := VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", 10)
	margin.add_child(inner_vbox)
	
	var title_lbl := Label.new()
	title_lbl.text = "LIVE CHAT: " + _room.get("artist", "ARTIST").replace("\n", " ")
	title_lbl.add_theme_color_override("font_color", acc)
	if _pixel_font: title_lbl.add_theme_font_override("font", _pixel_font)
	inner_vbox.add_child(title_lbl)
	
	_chat_log = RichTextLabel.new()
	_chat_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_chat_log.bbcode_enabled = true
	_chat_log.scroll_following = true
	_chat_log.add_theme_color_override("default_color", C_CREAM)
	if _body_font: _chat_log.add_theme_font_override("normal_font", _body_font)
	_chat_log.text = "[color=#888888]Connected to Artist Instance...[/color]\n"
	inner_vbox.add_child(_chat_log)
	
	var input_hbox := HBoxContainer.new()
	vbox.add_child(input_hbox)
	
	_chat_input = LineEdit.new()
	_chat_input.placeholder_text = "Say something..."
	_chat_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_chat_input.custom_minimum_size = Vector2(0, 40)
	var i_style := _flat(Color.WHITE, 0); i_style.content_margin_left = 10
	_chat_input.add_theme_stylebox_override("normal", i_style)
	_chat_input.add_theme_color_override("font_color", Color.BLACK)
	_chat_input.text_submitted.connect(_on_chat_submitted)
	input_hbox.add_child(_chat_input)
	
	var send_btn := Button.new()
	send_btn.text = "SEND"
	send_btn.custom_minimum_size = Vector2(80, 0)
	send_btn.add_theme_stylebox_override("normal", _flat(acc, 0))
	send_btn.add_theme_color_override("font_color", C_PANEL_DARK)
	if _pixel_font: send_btn.add_theme_font_override("font", _pixel_font)
	send_btn.pressed.connect(func(): _on_chat_submitted(_chat_input.text))
	input_hbox.add_child(send_btn)

func _toggle_chat() -> void:
	_chat_open = !_chat_open
	_chat_panel.visible = _chat_open
	if _chat_open:
		_chat_input.grab_focus()
		_chat_toggle_btn.text = "✖ CLOSE CHAT"
		AudioManager.play("click")
	else:
		_chat_toggle_btn.text = "💬 CHAT WITH ARTIST"

func _on_chat_submitted(text: String) -> void:
	if text.strip_edges().is_empty() or _chat_loading: return
	
	_chat_log.text += "\n[b]You:[/b] " + text + "\n"
	_chat_input.text = ""
	_chat_loading = true
	
	var artist = _room.get("artist", "ARTIST").replace("\n", " ")
	var user_name = AuthManager.current_user.get("display_name", "Fan")
	
	var system_prompt = "You are %s, the famous music artist. A fan named %s is talking to you. Respond as %s in a brief, friendly, and authentic way. Be cool, use some emoji, and stay in character. DO NOT use [*] or [size] tags in your response." % [artist, user_name, artist]
	
	var url = "https://text.pollinations.ai/" + text.uri_encode() + "?system=" + system_prompt.uri_encode() + "&model=openai-fast"
	
	_log_debug("CHAT REQUEST: " + url, "cyan")
	_chat_log.text += "[color=#f56b9e][i]... %s is typing ...[/i][/color]\n" % artist
	_chat_http.request(url)

func _sanitize_bbcode(text: String) -> String:
	# Godot RichTextLabel does not support standard [*] list tags
	var sanitized = text.replace("[*]", "• ")
	
	# Godot uses [font_size=X], not [size=X]
	var regex = RegEx.new()
	regex.compile("\\[size=.*?\\]")
	sanitized = regex.sub(sanitized, "", true)
	
	regex.compile("\\[/size\\]")
	sanitized = regex.sub(sanitized, "", true)
	
	return sanitized

func _on_chat_request_completed(result: int, code: int, _hdrs: PackedStringArray, body: PackedByteArray) -> void:
	_chat_loading = false
	
	_log_debug("CHAT RESPONSE - Code: %d, Result: %d" % [code, result], "yellow" if code == 200 else "red")
	if code != 200:
		_log_debug("RAW BODY: " + body.get_string_from_utf8().left(200), "gray")
	# Remove "typing" indicator (last line)
	var lines = _chat_log.text.split("\n")
	if lines.size() > 0:
		lines.remove_at(lines.size() - 1)
		_chat_log.text = "\n".join(lines)
		
	if result == HTTPRequest.RESULT_SUCCESS and code == 200:
		var response = body.get_string_from_utf8()
		var artist = _room.get("artist", "ARTIST").replace("\n", " ")
		_chat_log.text += "\n[b]%s:[/b] %s\n" % [artist, response]
		AudioManager.play("hover")
	elif code == 500:
		_chat_log.text += "\n[color=red]System: Artist's server is full. Try again in a minute.[/color]\n"
	else:
		_chat_log.text += "\n[color=red]System: Artist is busy backstage (Code: %d).[/color]\n" % code

func _on_watch_in_theatre_pressed() -> void:
	if not _cinema_active_id.is_empty():
		OS.shell_open("https://www.youtube.com/watch?v=" + _cinema_active_id)
		_hide_cinema()

# ── Debug UI ──────────────────────────────────────────────────────────────────
var _debug_overlay : CanvasLayer = null
var _debug_log : RichTextLabel = null

func _input(event: InputEvent) -> void:
	# Toggle Debug Overlay with Shift + D
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_D and Input.is_key_pressed(KEY_SHIFT):
			_toggle_debug()

func _toggle_debug() -> void:
	if _debug_overlay == null:
		_build_debug_ui()
	_debug_overlay.visible = !_debug_overlay.visible
	print("[DEBUG] Overlay Toggled: ", _debug_overlay.visible)

func _build_debug_ui() -> void:
	_debug_overlay = CanvasLayer.new()
	_debug_overlay.layer = 120
	add_child(_debug_overlay)
	
	var panel = PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.modulate.a = 0.9
	_debug_overlay.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var header = HBoxContainer.new()
	vbox.add_child(header)
	
	var title = Label.new()
	title.text = "SYSTEM DEBUG CONSOLE"
	header.add_child(title)
	
	var close_btn = Button.new()
	close_btn.text = "CLOSE (SHIFT+D)"
	close_btn.pressed.connect(func(): _debug_overlay.visible = false)
	header.add_child(close_btn)
	
	_debug_log = RichTextLabel.new()
	_debug_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_debug_log.bbcode_enabled = true
	_debug_log.scroll_following = true
	vbox.add_child(_debug_log)
	
	_debug_overlay.visible = false

func _log_debug(msg: String, color: String = "white") -> void:
	var timestamp = Time.get_time_string_from_system()
	var formatted = "[color=%s][%s] %s[/color]\n" % [color, timestamp, msg]
	if _debug_log:
		_debug_log.text += formatted
	print("[DEBUG] ", msg)

# ── Lifecycle ──────────────────────────────────────────────────────────────────
func _ready() -> void:
	_pixel_font = load("res://Pixelify_Sans/static/PixelifySans-Bold.ttf") as FontFile
	_body_font  = load("res://font/Montserrat/static/Montserrat-SemiBold.ttf") as FontFile
	_room = RoomRegistry.current_room
	if _room.is_empty():
		_room = {"artist": "ARTIST", "genre": "Music", "crowd": 0,
			"bg_color1": C_BG, "accent": C_PINK}
	_build_ui()
	_build_cinema_ui()

# ══════════════════════════════════════════════════════════════════════════════
# UI CONSTRUCTION
# ══════════════════════════════════════════════════════════════════════════════

func _build_ui() -> void:
	var acc : Color = _room.get("accent", C_PINK)

	# Full background
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Subtle top glow tinted to the artist's accent colour
	var glow := ColorRect.new()
	glow.color = Color(acc.r, acc.g, acc.b, 0.07)
	glow.anchor_left = 0.0; glow.anchor_top = 0.0
	glow.anchor_right = 1.0; glow.anchor_bottom = 0.35
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(glow)

	_build_top_bar()
	_build_journey_scroll()
	_build_ai_ui()
	_build_chat_ui()

# ── TOP BAR ────────────────────────────────────────────────────────────────────
func _add_topbar_credits_indicator(parent: Control) -> void:
	var credits = AuthManager.current_user.get("avatar_credits", 0)
	var acc : Color = _room.get("accent", C_PINK)
	
	var badge := Button.new()
	badge.custom_minimum_size = Vector2(110, 28)
	badge.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.12, 0.20, 0.8)
	style.set_corner_radius_all(14)
	style.border_width_left   = 1
	style.border_width_right  = 1
	style.border_width_top    = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.92, 0.75, 0.48, 0.5) # Gold-ish
	
	var hover_style := style.duplicate()
	hover_style.bg_color = Color(0.20, 0.16, 0.26, 0.9)
	
	badge.add_theme_stylebox_override("normal", style)
	badge.add_theme_stylebox_override("hover", hover_style)
	badge.add_theme_stylebox_override("pressed", style)
	badge.add_theme_stylebox_override("focus", style)
	
	badge.pressed.connect(func():
		AudioManager.play("click")
		get_tree().change_scene_to_file("res://screens/top_up.tscn")
	)
	
	var margin := MarginContainer.new()
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	badge.add_child(margin)
	
	var hbox := HBoxContainer.new()
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 8)
	margin.add_child(hbox)
	
	var lbl := Label.new()
	lbl.text = "Credits: %d" % credits
	lbl.add_theme_color_override("font_color", Color(0.92, 0.75, 0.48)) # Gold
	lbl.add_theme_font_size_override("font_size", 12)
	if _body_font:
		lbl.add_theme_font_override("font", _body_font)
	hbox.add_child(lbl)
	
	parent.add_child(badge)



func _build_top_bar() -> void:
	var acc : Color = _room.get("accent", C_PINK)

	var bar := PanelContainer.new()
	bar.anchor_left   = 0.0
	bar.anchor_top    = 0.0
	bar.anchor_right  = 1.0
	bar.anchor_bottom = 0.0
	bar.offset_bottom = 56.0
	var bar_style := StyleBoxFlat.new()
	bar_style.bg_color = C_PANEL_DARK
	bar_style.border_width_bottom = 1
	bar_style.border_color = Color(acc.r, acc.g, acc.b, 0.30)
	bar.add_theme_stylebox_override("panel", bar_style)
	add_child(bar)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left",  14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top",    8)
	margin.add_theme_constant_override("margin_bottom", 8)
	bar.add_child(margin)

	var hbox := HBoxContainer.new()
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin.add_child(hbox)

	# Back button
	var back_btn := Button.new()
	back_btn.text = "← BACK"
	back_btn.flat = false
	back_btn.custom_minimum_size = Vector2(90, 36)
	back_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var sn := _flat(Color(acc.r, acc.g, acc.b, 0.15), 18)
	var sh := _flat(Color(acc.r, acc.g, acc.b, 0.30), 18)
	back_btn.add_theme_stylebox_override("normal",  sn)
	back_btn.add_theme_stylebox_override("hover",   sh)
	back_btn.add_theme_stylebox_override("pressed", sn)
	back_btn.add_theme_color_override("font_color", acc)
	back_btn.add_theme_font_size_override("font_size", 12)
	if _pixel_font:
		back_btn.add_theme_font_override("font", _pixel_font)
	back_btn.pressed.connect(_on_leave_pressed)
	hbox.add_child(back_btn)

	# Spacer
	var sp1 := Control.new()
	sp1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sp1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(sp1)

	# Centre: artist name + subtitle
	var centre_vbox := VBoxContainer.new()
	centre_vbox.add_theme_constant_override("separation", 1)
	centre_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(centre_vbox)

	var artist_name_lbl := Label.new()
	artist_name_lbl.text = _room.get("artist", "ARTIST").replace("\n", " ")
	artist_name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	artist_name_lbl.add_theme_color_override("font_color", C_CREAM)
	artist_name_lbl.add_theme_font_size_override("font_size", 20)
	if _pixel_font:
		artist_name_lbl.add_theme_font_override("font", _pixel_font)
	artist_name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	centre_vbox.add_child(artist_name_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "the journey"
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.add_theme_color_override("font_color", Color(acc.r, acc.g, acc.b, 0.85))
	sub_lbl.add_theme_font_size_override("font_size", 10)
	if _body_font:
		sub_lbl.add_theme_font_override("font", _body_font)
	sub_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	centre_vbox.add_child(sub_lbl)

	# Spacer
	var sp2 := Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sp2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(sp2)
	
	# Credits Indicator
	_add_topbar_credits_indicator(hbox)

	# Genre badge (right side, same width as back button for balance)
	var genre_lbl := Label.new()
	genre_lbl.text = _room.get("genre", "").to_upper()
	genre_lbl.custom_minimum_size = Vector2(90, 36)
	genre_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	genre_lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	genre_lbl.add_theme_color_override("font_color", Color(C_MUTED.r, C_MUTED.g, C_MUTED.b, 0.7))
	genre_lbl.add_theme_font_size_override("font_size", 10)
	if _body_font:
		genre_lbl.add_theme_font_override("font", _body_font)
	genre_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_child(genre_lbl)

# ── JOURNEY SCROLL ─────────────────────────────────────────────────────────────
func _build_journey_scroll() -> void:
	var artist_key : String = _room.get("artist", "")
	var entries : Array = CONCERT_TOURS.get(artist_key, [])
	var acc : Color = _room.get("accent", C_PINK)

	# Outer scroll container — fills below the top bar
	var scroll := ScrollContainer.new()
	scroll.anchor_left   = 0.0
	scroll.anchor_top    = 0.0
	scroll.anchor_right  = 1.0
	scroll.anchor_bottom = 1.0
	scroll.offset_top    = 56.0
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode   = ScrollContainer.SCROLL_MODE_AUTO
	add_child(scroll)

	# Inner margin for readable line length
	var inner_margin := MarginContainer.new()
	inner_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner_margin.add_theme_constant_override("margin_left",  24)
	inner_margin.add_theme_constant_override("margin_right", 24)
	inner_margin.add_theme_constant_override("margin_top",   28)
	inner_margin.add_theme_constant_override("margin_bottom", 60)
	scroll.add_child(inner_margin)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 0)
	inner_margin.add_child(vbox)

	# Introduction header
	_add_intro_header(vbox, artist_key, acc)

	# Timeline entries
	for i : int in entries.size():
		var entry : Dictionary = entries[i]
		_add_timeline_entry(vbox, entry, acc, i, entries.size())

	# Closing flourish
	_add_closing_flourish(vbox, acc)

# ── INTRO HEADER ───────────────────────────────────────────────────────────────
func _add_intro_header(parent: VBoxContainer, artist_key: String, acc: Color) -> void:
	var name_str : String = artist_key.replace("\n", " ")

	# Large decorative accent line
	var top_line := ColorRect.new()
	top_line.custom_minimum_size = Vector2(0, 3)
	top_line.color = acc
	parent.add_child(top_line)

	var spacer_top := Control.new()
	spacer_top.custom_minimum_size = Vector2(0, 20)
	parent.add_child(spacer_top)

	var heading := Label.new()
	heading.text = "CONCERT HISTORY OF " + name_str.to_upper()
	heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_color_override("font_color", C_CREAM)
	heading.add_theme_font_size_override("font_size", 24)
	if _pixel_font:
		heading.add_theme_font_override("font", _pixel_font)
	heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(heading)

	var subhead := Label.new()
	subhead.text = "the defining tours and live performances"
	subhead.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subhead.add_theme_color_override("font_color", Color(acc.r, acc.g, acc.b, 0.70))
	subhead.add_theme_font_size_override("font_size", 12)
	if _body_font:
		subhead.add_theme_font_override("font", _body_font)
	subhead.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(subhead)

	var spacer_bottom := Control.new()
	spacer_bottom.custom_minimum_size = Vector2(0, 28)
	parent.add_child(spacer_bottom)

	# Thin separator
	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(acc.r, acc.g, acc.b, 0.18)
	parent.add_child(sep)

	var spacer_after_sep := Control.new()
	spacer_after_sep.custom_minimum_size = Vector2(0, 28)
	parent.add_child(spacer_after_sep)

# ── TIMELINE ENTRY ─────────────────────────────────────────────────────────────
func _add_timeline_entry(
	parent    : VBoxContainer,
	entry     : Dictionary,
	acc       : Color,
	idx       : int,
	total     : int
) -> void:
	# Outer row: timeline spine on left, content on right
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 18)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(row)

	# ── Left spine column ──────────────────────────────────────────────────────
	var spine_col := VBoxContainer.new()
	spine_col.custom_minimum_size = Vector2(52, 0)
	spine_col.add_theme_constant_override("separation", 0)
	spine_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(spine_col)

	# Top connector line (hidden on first entry)
	var top_line := ColorRect.new()
	top_line.custom_minimum_size = Vector2(2, 18)
	top_line.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	top_line.color = Color(acc.r, acc.g, acc.b, 0.30 if idx > 0 else 0.0)
	top_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spine_col.add_child(top_line)

	# Year dot/badge
	var dot_panel := PanelContainer.new()
	dot_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var dot_style := StyleBoxFlat.new()
	dot_style.bg_color = acc
	dot_style.set_corner_radius_all(0) # Consistency: Blocky
	dot_style.content_margin_left   = 8
	dot_style.content_margin_right  = 8
	dot_style.content_margin_top    = 4
	dot_style.content_margin_bottom = 4
	dot_panel.add_theme_stylebox_override("panel", dot_style)
	spine_col.add_child(dot_panel)

	var year_lbl := Label.new()
	year_lbl.text = entry.get("year", "")
	year_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	year_lbl.add_theme_color_override("font_color", C_PANEL_DARK)
	year_lbl.add_theme_font_size_override("font_size", 10)
	if _pixel_font:
		year_lbl.add_theme_font_override("font", _pixel_font)
	year_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dot_panel.add_child(year_lbl)

	# Bottom connector line (hidden on last entry)
	var bottom_line := ColorRect.new()
	bottom_line.custom_minimum_size = Vector2(2, 0)
	bottom_line.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	bottom_line.size_flags_vertical   = Control.SIZE_EXPAND_FILL
	bottom_line.color = Color(acc.r, acc.g, acc.b, 0.30 if idx < total - 1 else 0.0)
	bottom_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spine_col.add_child(bottom_line)

	# ── Right content card ─────────────────────────────────────────────────────
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.size_flags_vertical   = Control.SIZE_SHRINK_BEGIN
	card.mouse_filter = Control.MOUSE_FILTER_STOP # Capture input
	
	# Set pivot to center for better scaling
	card.pivot_offset = Vector2(300, 50) # Estimated
	
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(lerpf(C_PANEL.r, acc.r, 0.02), lerpf(C_PANEL.g, acc.g, 0.02), lerpf(C_PANEL.b, acc.b, 0.02))
	card_style.set_corner_radius_all(0) # Consistency: Blocky
	card_style.border_width_left   = 4
	card_style.border_color        = acc
	card_style.shadow_color        = Color(0, 0, 0, 0.8)
	card_style.shadow_size         = 0
	card_style.shadow_offset       = Vector2(6, 6)
	card_style.content_margin_left   = 16
	card_style.content_margin_right  = 16
	card_style.content_margin_top    = 14
	card_style.content_margin_bottom = 14
	card.add_theme_stylebox_override("panel", card_style)
	row.add_child(card)
	
	var yt_id = entry.get("youtube_id", "")
	if not yt_id.is_empty():
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		# Optional: Add a small "PLAY" indicator
		var play_badge := Label.new()
		play_badge.text = "▶ WATCH VIDEO"
		play_badge.add_theme_color_override("font_color", acc)
		play_badge.add_theme_font_size_override("font_size", 9)
		if _pixel_font: play_badge.add_theme_font_override("font", _pixel_font)
		play_badge.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
		play_badge.offset_top = 8; play_badge.offset_right = -12
		play_badge.modulate.a = 0.0
		card.add_child(play_badge)

		card.mouse_entered.connect(func():
			# Recalculate pivot on the fly
			card.pivot_offset = card.size / 2.0
			var tw = create_tween().set_parallel(true)
			tw.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)
			tw.tween_property(card_style, "shadow_offset", Vector2(10, 10), 0.1)
			tw.tween_property(play_badge, "modulate:a", 1.0, 0.1)
			AudioManager.play("hover")
		)
		card.mouse_exited.connect(func():
			var tw = create_tween().set_parallel(true)
			tw.tween_property(card, "scale", Vector2(1.0, 1.0), 0.1)
			tw.tween_property(card_style, "shadow_offset", Vector2(6, 6), 0.1)
			tw.tween_property(play_badge, "modulate:a", 0.0, 0.1)
		)
		card.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				AudioManager.play("click")
				_show_cinema(entry)
		)
	else:
		# Fallback hover for non-video entries
		card.mouse_entered.connect(func():
			card.pivot_offset = card.size / 2.0
			var tw = create_tween().set_parallel(true)
			tw.tween_property(card, "scale", Vector2(1.02, 1.02), 0.1)
			tw.tween_property(card_style, "shadow_offset", Vector2(10, 10), 0.1)
		)
		card.mouse_exited.connect(func():
			var tw = create_tween().set_parallel(true)
			tw.tween_property(card, "scale", Vector2(1.0, 1.0), 0.1)
			tw.tween_property(card_style, "shadow_offset", Vector2(6, 6), 0.1)
		)

	var card_vbox := VBoxContainer.new()
	card_vbox.add_theme_constant_override("separation", 8)
	card_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(card_vbox)

	# Entry title
	var title_lbl := Label.new()
	title_lbl.text = entry.get("title", "")
	title_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title_lbl.add_theme_color_override("font_color", C_GOLD_LIGHT)
	title_lbl.add_theme_font_size_override("font_size", 15)
	if _pixel_font:
		title_lbl.add_theme_font_override("font", _pixel_font)
	title_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_vbox.add_child(title_lbl)

	# Thin accent rule under the title
	var rule := ColorRect.new()
	rule.custom_minimum_size = Vector2(0, 1)
	rule.color = Color(acc.r, acc.g, acc.b, 0.22)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_vbox.add_child(rule)

	# Body text
	var body_lbl := Label.new()
	body_lbl.text = entry.get("text", "")
	body_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body_lbl.add_theme_color_override("font_color", Color(C_CREAM.r, C_CREAM.g, C_CREAM.b, 0.82))
	body_lbl.add_theme_font_size_override("font_size", 12)
	if _body_font:
		body_lbl.add_theme_font_override("font", _body_font)
	body_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_vbox.add_child(body_lbl)

	# Spacing after card before next entry
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 16)
	parent.add_child(gap)

# ── CLOSING FLOURISH ───────────────────────────────────────────────────────────
func _add_closing_flourish(parent: VBoxContainer, acc: Color) -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 12)
	parent.add_child(spacer)

	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(acc.r, acc.g, acc.b, 0.18)
	parent.add_child(sep)

	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	parent.add_child(spacer2)

	var end_lbl := Label.new()
	end_lbl.text = "✦  the story continues  ✦"
	end_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_lbl.add_theme_color_override("font_color", Color(acc.r, acc.g, acc.b, 0.45))
	end_lbl.add_theme_font_size_override("font_size", 11)
	if _body_font:
		end_lbl.add_theme_font_override("font", _body_font)
	end_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(end_lbl)

# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

func _flat(col: Color, radius: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = col
	if radius > 0:
		s.set_corner_radius_all(radius)
	return s

func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(HOME_SCENE)

# ── AI CONCERT HISTORY ────────────────────────────────────────────────────────
var _ai_panel : PanelContainer = null
var _ai_loading : Label = null
var _ai_open : bool = false
var _ai_char_idx : int = 0

# Separate storage for the two tabs
var _history_text : String = ""
var _tophits_text : String = ""
var _history_label : RichTextLabel = null
var _tophits_label : RichTextLabel = null

var _ai_toggle_btn : Button = null

func _build_ai_ui() -> void:
	# 1. The slide-out panel
	_ai_panel = PanelContainer.new()
	var acc : Color = _room.get("accent", C_PINK)
	_ai_panel.anchor_left = 1.0
	_ai_panel.anchor_top = 0.0
	_ai_panel.anchor_right = 1.0
	_ai_panel.anchor_bottom = 1.0
	_ai_panel.offset_left = 0
	_ai_panel.offset_right = 400
	_ai_panel.offset_top = 56
	_ai_panel.visible = false
	
	var style := StyleBoxFlat.new()
	style.bg_color = C_PANEL_DARK
	style.border_width_left = 2
	style.border_color = acc
	_ai_panel.add_theme_stylebox_override("panel", style)
	add_child(_ai_panel)
	
	var margin := MarginContainer.new()
	margin.name = "MarginContainer"
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	_ai_panel.add_child(margin)
	
	var vbox := VBoxContainer.new()
	vbox.name = "VBoxContainer"
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)
	
	var title := Label.new()
	title.name = "Title"
	title.text = "Artist Biography"
	title.add_theme_color_override("font_color", C_GOLD_LIGHT)
	title.add_theme_font_size_override("font_size", 16)
	if _pixel_font: title.add_theme_font_override("font", _pixel_font)
	vbox.add_child(title)
	
	var sep := ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(acc.r, acc.g, acc.b, 0.3)
	vbox.add_child(sep)
	
	_ai_loading = Label.new()
	_ai_loading.text = "Generating..."
	_ai_loading.visible = false
	_ai_loading.add_theme_color_override("font_color", C_CREAM)
	if _body_font: _ai_loading.add_theme_font_override("font", _body_font)
	vbox.add_child(_ai_loading)
	
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)
	
	var scroll_margin := MarginContainer.new()
	scroll_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_margin.add_theme_constant_override("margin_right", 12)
	scroll.add_child(scroll_margin)
	
	# Container for labels to switch visibility
	var labels_vbox := VBoxContainer.new()
	scroll_margin.add_child(labels_vbox)

	_history_label = RichTextLabel.new()
	_history_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_history_label.fit_content = true
	_history_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_history_label.bbcode_enabled = true
	_history_label.add_theme_color_override("default_color", C_CREAM)
	if _body_font: _history_label.add_theme_font_override("normal_font", _body_font)
	_history_label.add_theme_font_size_override("normal_font_size", 12)
	_history_label.meta_clicked.connect(_on_ai_link_clicked)
	labels_vbox.add_child(_history_label)

	_tophits_label = RichTextLabel.new()
	_tophits_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_tophits_label.fit_content = true
	_tophits_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_tophits_label.bbcode_enabled = true
	_tophits_label.add_theme_color_override("default_color", C_CREAM)
	if _body_font: _tophits_label.add_theme_font_override("normal_font", _body_font)
	_tophits_label.add_theme_font_size_override("normal_font_size", 12)
	_tophits_label.meta_clicked.connect(_on_ai_link_clicked)
	_tophits_label.visible = false
	labels_vbox.add_child(_tophits_label)
	
	# Spacer
	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 10)
	vbox.add_child(gap)

	# Book Concert Button
	var book_btn := Button.new()
	book_btn.text = "Book a concert now?"
	book_btn.custom_minimum_size = Vector2(0, 40)
	book_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var b_norm := _flat(C_PANEL, 6)
	b_norm.border_width_left = 1; b_norm.border_width_right = 1
	b_norm.border_width_top = 1; b_norm.border_width_bottom = 1
	b_norm.border_color = acc
	var b_hov := _flat(acc, 6)
	
	book_btn.add_theme_stylebox_override("normal", b_norm)
	book_btn.add_theme_stylebox_override("hover", b_hov)
	book_btn.add_theme_color_override("font_color", C_CREAM)
	book_btn.add_theme_color_override("font_hover_color", C_PANEL_DARK)
	if _body_font: book_btn.add_theme_font_override("font", _body_font)
	
	book_btn.pressed.connect(func():
		var artist : String = _room.get("artist", "ARTIST").replace("\n", " ")
		var url = "https://www.ticketmaster.com/search?q=" + artist.replace(" ", "%20")
		OS.shell_open(url)
		AudioManager.play("click")
	)
	vbox.add_child(book_btn)
	
	# 2. The toggle buttons for AI Panels
	var btns_vbox := VBoxContainer.new()
	btns_vbox.anchor_left = 1.0; btns_vbox.anchor_top = 0.5
	btns_vbox.anchor_right = 1.0; btns_vbox.anchor_bottom = 0.5
	btns_vbox.offset_left = -160; btns_vbox.offset_top = -50
	btns_vbox.offset_right = 0; btns_vbox.offset_bottom = 50
	btns_vbox.add_theme_constant_override("separation", 10)
	btns_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(btns_vbox)
	
	_ai_toggle_btn = Button.new()
	_ai_toggle_btn.text = "✦ ARTIST HISTORY"
	_ai_toggle_btn.custom_minimum_size = Vector2(0, 45)
	_ai_toggle_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	var sn := _flat(C_PANEL, 8)
	sn.border_width_left = 2; sn.border_width_top = 2; sn.border_width_bottom = 2
	sn.border_color = acc
	var sh := _flat(acc, 8)
	
	_ai_toggle_btn.add_theme_stylebox_override("normal", sn)
	_ai_toggle_btn.add_theme_stylebox_override("hover", sh)
	_ai_toggle_btn.add_theme_stylebox_override("pressed", sn)
	_ai_toggle_btn.add_theme_color_override("font_color", C_CREAM)
	if _pixel_font: _ai_toggle_btn.add_theme_font_override("font", _pixel_font)
	_ai_toggle_btn.pressed.connect(_on_ai_button_pressed)
	btns_vbox.add_child(_ai_toggle_btn)

	var top_hit_btn := Button.new()
	top_hit_btn.text = "♫ TOP HIT SONG"
	top_hit_btn.custom_minimum_size = Vector2(0, 45)
	top_hit_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	top_hit_btn.add_theme_stylebox_override("normal", sn)
	top_hit_btn.add_theme_stylebox_override("hover", sh)
	top_hit_btn.add_theme_stylebox_override("pressed", sn)
	top_hit_btn.add_theme_color_override("font_color", C_CREAM)
	if _pixel_font: top_hit_btn.add_theme_font_override("font", _pixel_font)
	top_hit_btn.pressed.connect(_on_top_hit_button_pressed)
	btns_vbox.add_child(top_hit_btn)
	
	# Store VBox ref to animate it
	_btns_vbox = btns_vbox

var _btns_vbox : VBoxContainer = null
var _ai_current_mode : String = "" # "history" or "tophits"

func _on_top_hit_button_pressed() -> void:
	if _ai_panel.visible and _ai_open and _ai_current_mode == "tophits":
		_close_ai_panel()
	else:
		_ai_current_mode = "tophits"
		_open_ai_panel("Top Hits & Stats")

func _on_ai_button_pressed() -> void:
	if _ai_panel.visible and _ai_open and _ai_current_mode == "history":
		_close_ai_panel()
	else:
		_ai_current_mode = "history"
		_open_ai_panel("Artist Biography")

func _open_ai_panel(title_text: String) -> void:
	_ai_panel.get_node("MarginContainer/VBoxContainer/Title").text = title_text
	_ai_panel.visible = true
	_ai_open = true
	
	# Switch label visibility
	_history_label.visible = (_ai_current_mode == "history")
	_tophits_label.visible = (_ai_current_mode == "tophits")
	
	var tw := create_tween().set_parallel(true)
	tw.tween_property(_ai_panel, "offset_left", -400, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_ai_panel, "offset_right", 0, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_btns_vbox, "offset_left", -560, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_btns_vbox, "offset_right", -400, 0.3).set_trans(Tween.TRANS_SINE)
	
	if _ai_current_mode == "history":
		if _history_text.is_empty():
			_generate_ai_history()
	else:
		if _tophits_text.is_empty():
			_generate_top_hit_info()

func _close_ai_panel() -> void:
	_ai_open = false
	var tw := create_tween().set_parallel(true)
	tw.tween_property(_ai_panel, "offset_left", 0, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_ai_panel, "offset_right", 400, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_btns_vbox, "offset_left", -160, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_btns_vbox, "offset_right", 0, 0.3).set_trans(Tween.TRANS_SINE)
	tw.chain().tween_callback(func(): _ai_panel.visible = false)

func _generate_top_hit_info() -> void:
	if _ai_loading.visible:
		return
	
	var artist : String = _room.get("artist", "ARTIST").replace("\n", " ")
	_ai_loading.visible = true
	_ai_loading.text = "Waiting for %s to reply..." % artist
	_tophits_label.text = ""
	
	# Prompt for AI-generated stats
	var system_prompt = "You are %s, the famous music artist. Provide your top 3 hits and some fun monthly listener statistics in a brief, friendly, and authentic way. Be cool, use some emoji, and stay in character. Format it clearly using BBCode (like [b] for bold) so it reads like a personalized retro RPG stats screen. DO NOT use [*] or [size] tags, just use standard numbers or bullets for lists and basic tags like [b], [i], and [color]." % artist
	var user_prompt = "Can you share your top hits and current stats with me?"

	var url = "https://text.pollinations.ai/" + user_prompt.uri_encode() + "?system=" + system_prompt.uri_encode() + "&model=openai-fast"
	
	_log_debug("TOP HITS REQUEST: " + url, "cyan")
	print("[ConcertRoom] Requesting Top Hits from: ", url)
	
	var http = HTTPRequest.new()
	add_child(http)
	http.timeout = 15.0
	
	http.request_completed.connect(func(result, code, _h, body_bytes):
		_ai_loading.visible = false
		
		if result != HTTPRequest.RESULT_SUCCESS:
			_tophits_label.text = "System: Network error. Check your connection."
			http.queue_free()
			return

		if code == 200:
			_tophits_text = "[center][b]✦ %s GLOBAL STATS ✦[/b][/center]\n\n" % artist.to_upper()
			var content = body_bytes.get_string_from_utf8()
			content = _sanitize_bbcode(content)
			_tophits_text += content
			_tophits_label.text = _tophits_text
			_tophits_label.visible_ratio = 0.0
			var tw = create_tween()
			tw.tween_property(_tophits_label, "visible_ratio", 1.0, _tophits_text.length() * 0.010)
		elif code == 500:
			_tophits_label.text = "System: AI provider maintenance (Server Full). Please try again later."
		else:
			_tophits_label.text = "System: AI Service busy (Code: %d)." % code
			
		http.queue_free()
	)
	
	var err = http.request(url)
	if err != OK:
		_ai_loading.visible = false
		_tophits_label.text = "System: Failed to initiate request (Err: %d)" % err
		http.queue_free()

func _generate_ai_history() -> void:
	if _ai_loading.visible:
		return
		
	var artist : String = _room.get("artist", "ARTIST").replace("\n", " ")
	var artist_key : String = _room.get("artist", "")
	
	_ai_loading.visible = true
	_history_label.text = ""
	
	await get_tree().create_timer(1.0).timeout
	
	_ai_loading.visible = false
	
	var history_entries : Array = JOURNEYS.get(artist_key, [])
	var history_text = ""
	
	if history_entries.is_empty():
		history_text = "✦ Information about this artist's biography is currently being updated.\n\n"
	else:
		for i in range(min(5, history_entries.size())): # show up to 5 defining eras
			var entry = history_entries[i]
			history_text += "[b]%s - %s:[/b]\n%s\n\n" % [entry.get("year", ""), entry.get("title", ""), entry.get("text", "")]
		
	var mock_response := "[b]The Journey of %s:[/b]\n\n" % artist
	mock_response += history_text
	
	mock_response += "[b]Upcoming / Ongoing Concerts:[/b]\n"
	mock_response += "[url=https://www.ticketmaster.com/search?q=%s]✦ Find %s Tickets on Ticketmaster[/url]\n" % [artist.replace(" ", "%20"), artist]
	mock_response += "[url=https://www.bandsintown.com/a/%s]✦ View %s Tour Dates on Bandsintown[/url]" % [artist.replace(" ", "%20"), artist]
	
	_history_text = mock_response
	
	_history_label.text = _history_text
	_history_label.visible_ratio = 0.0
	var tw = create_tween()
	tw.tween_property(_history_label, "visible_ratio", 1.0, _history_text.length() * 0.010)

func _on_ai_link_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

