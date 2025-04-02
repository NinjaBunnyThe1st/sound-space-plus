extends Button

signal lock_type

var has_been_pressed: bool = false
var detected_controllers: int = Input.get_connected_joypads().size()
var _search_node: Node = null

func _ready():
	var scene_root = get_tree().get_root()
	if Rhythia.vr:
		var viewport = scene_root.get_node("VRMenuHolder/PointerScreen/Viewport")
		if viewport:
			_search_node = viewport.get_node("Menu/Main/Maps/MapRegistry/T/AuthorSearch")
	else:
		_search_node = scene_root.get_node("Menu/Main/Maps/MapRegistry/T/AuthorSearch")
	if not _search_node:
		push_error("Could not find AuthorSearch node!")
		return
	
	get_tree().connect("files_dropped", self, "files_dropped")

func _input(event: InputEvent):
	if not is_visible_in_tree(): return
	
	# Use stored node reference instead of get_node()
	if _search_node and _search_node.visible:
		return
	
	if get_viewport().get_node("Menu/Main/Maps/Results").visible == true:
		if !disabled && !has_been_pressed && event is InputEventJoypadButton:
			if event.button_index == JOY_XBOX_A && event.pressed:
				grab_focus()
				grab_click_focus()
				pressed = true
		if !disabled && !has_been_pressed && event is InputEventKey:
			if event.pressed and event.scancode == KEY_SPACE:
				grab_focus()
				grab_click_focus()
				pressed = true

func _pressed():
	if !Rhythia.selected_song: return
	if has_been_pressed: return
	emit_signal("lock_type")
	
	if detected_controllers >= 1 and !Rhythia.ignore_controller_detection:
		var sel = 1
		Globals.confirm_prompt.s_alert.play()
		Globals.confirm_prompt.open("A controller or joypad was detected.\nWould you like to play the song with it?\n\n(Connected controllers may cause your cursor to not work when using your mouse!)","Possible controller detected",[{text="No"},{text="Yes",wait=2}])
		if !Rhythia.vr:
			sel = yield(Globals.confirm_prompt,"option_selected")
			Globals.confirm_prompt.s_next.play()
		Globals.confirm_prompt.close()
		yield(Globals.confirm_prompt,"done_closing")
		if bool(sel):
			Rhythia.ignore_controller_detection = true
			has_been_pressed = true
			get_viewport().get_node("Menu").black_fade_target = true
			yield(get_tree().create_timer(0.35),"timeout")
			get_tree().change_scene("res://scenes/loaders/songload.tscn")
			return
	else:
		get_viewport().get_node("Menu").black_fade_target = true
		yield(get_tree().create_timer(0.35),"timeout")
		get_tree().change_scene("res://scenes/loaders/songload.tscn")
