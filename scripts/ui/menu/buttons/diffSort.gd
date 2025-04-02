extends VBoxContainer
onready var G = get_parent().get_node("MapRegistry/S/VBoxContainer")
var active:bool = false

func setc(n:Control,v:bool):
	if v: n.modulate = Color(1,1,1,1)
	else: n.modulate = Color(0.5,0.5,0.5,1)

func upd(_1=0,_2=0,_3=0):
	setc($NODIF,G.difficulty_filter.has(-1))
	setc($EASY,G.difficulty_filter.has(0))
	setc($MEDIUM,G.difficulty_filter.has(1))
	setc($HARD,G.difficulty_filter.has(2))
	setc($LOGIC,G.difficulty_filter.has(3))
	setc($AMOGUS,G.difficulty_filter.has(4))

func tg(d:int):
	G.get_node("Press").play()
	if G.difficulty_filter.has(d):
		G.difficulty_filter.remove(G.difficulty_filter.find(d))
	else: G.difficulty_filter.append(d)
	G.update_search_dfil(G.difficulty_filter)

func _ready():
	$NODIF/Select.connect("pressed",self,"tg",[-1])
	$EASY/Select.connect("pressed",self,"tg",[0])
	$MEDIUM/Select.connect("pressed",self,"tg",[1])
	$HARD/Select.connect("pressed",self,"tg",[2])
	$LOGIC/Select.connect("pressed",self,"tg",[3])
	$AMOGUS/Select.connect("pressed",self,"tg",[4])
	G.connect("search_updated",self,"upd")
	upd()
