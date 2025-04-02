extends Button

signal lock_type

var has_been_pressed: bool = false
var detected_controllers: int = Input.get_connected_joypads().size()
var _search_node: Node = null
onready var G = get_parent().get_parent().get_parent().get_node("MapRegistry/S/VBoxContainer")
func _input(event: InputEvent):
	if not is_visible_in_tree(): return
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
	var d=1
	G.get_node("Press").play()
	if G.difficulty_filter.has(d):
		G.difficulty_filter.remove(G.difficulty_filter.find(d))
	else: G.difficulty_filter.append(d)
	G.update_search_dfil(G.difficulty_filter)
