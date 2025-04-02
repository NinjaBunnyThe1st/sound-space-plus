# now supports vr (fully remade)
extends LineEdit

var _search_node: Node = null
var _results_node: Node = null
var _run_node: Node = null

func _ready():
	
	set_editable(true)
	var scene_root = get_tree().get_root()
	if Rhythia.vr:
		# Get the viewport directly
		var viewport = scene_root.get_node("/root/VRMenuHolder/PointerScreen/Viewport")
		_search_node = viewport.get_node("Menu/Main/Maps/MapRegistry/T/AuthorSearch")
		_results_node = viewport.get_node("Menu/Main/Maps/Results/Results/RS/H2/Mods/SpeedMod/C/CustomSpeed")
		_run_node = viewport.get_node("Menu/Main/Maps/Results/Results/RS/H1/Info/Run")
	else:
		_search_node = scene_root.get_node("Menu/Main/Maps/MapRegistry/T/AuthorSearch")
		_results_node = scene_root.get_node("Menu/Main/Maps/Results/Results/RS/H2/Mods/SpeedMod/C/CustomSpeed")
		_run_node = scene_root.get_node("Menu/Main/Maps/Results/Results/RS/H1/Info/Run")
	
	if not _search_node or not _results_node or not _run_node:
		push_error("Could not find required nodes!")
		return
	
	text = Rhythia.last_search_str
	update_txt()
	connect("text_changed", self, "update_txt")
	get_parent().get_parent().get_node("S/VBoxContainer").connect("reset_filters",self,"_on_reset_filters")
	get_parent().get_parent().get_node("S/VBoxContainer").connect("lock_type",self,"_on_lock_type")
	get_parent().get_parent().get_parent().get_node("Results/Results/RS/H1/Info/Run").connect("lock_type",self,"_on_lock_type")
	
	
	
func _on_reset_filters():
	text = ""
	update_txt()
func update_txt(_v=null):
	if _search_node:
		_search_node.update_txt(text)
	Rhythia.last_search_str = text
	
func _on_lock_type():
	set_editable(false)

func _input(event):
	if !Rhythia.vr:
		if get_focus_owner() == self: return
		if get_focus_owner() == $"/root/Menu/Main/Maps/MapRegistry/T/AuthorSearch": return
		if get_focus_owner() == $"/root/Menu/Main/Maps/Results/Results/RS/H2/Mods/SpeedMod/C/CustomSpeed".get_line_edit(): return
		if get_focus_owner() == $"/root/Menu/Main/Maps/Results/Results/RS/H2/Mods/StartOffset/TimeTextBox": return
	else:
		if get_focus_owner() == self: return
		if get_focus_owner() == $"/root/VRMenuHolder/PointerScreen/Viewport/Menu/Main/Maps/MapRegistry/T/AuthorSearch": return
		if get_focus_owner() == $"/root/VRMenuHolder/PointerScreen/Viewport/Menu/Main/Maps/Results/Results/RS/H2/Mods/SpeedMod/C/CustomSpeed".get_line_edit(): return
		if get_focus_owner() == $"/root/VRMenuHolder/PointerScreen/Viewport/Menu/Main/Maps/Results/Results/RS/H2/Mods/StartOffset/TimeTextBox": return
	if not is_visible_in_tree():
		return
		
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_SPACE:
			return
		if event.scancode == KEY_BACKSPACE:
			if len(text) == 0:
				return
			else:
				clear()
				grab_focus()
		var unicode = event.get_unicode()
		if unicode != 0:
			grab_focus()
