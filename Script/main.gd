extends Node

const CONS = preload("res://Script/constants.gd")
const CONV = preload("res://Script/convert.gd")
const Playing = preload("res://Scene/Playing.tscn")

var playing_scene

var table_data = [
"""3,0,s
___o___
.......
.......
.s....#
...#.#.
.>...g.
.......

""",

"""8,6,s
.>..v.#..<.
.....#..#..
......^....
>.#.......#
...>..#.>^.
.....s.....
.#.........
.#...o...#.
......^....
.......#...
^..........
..#^....<.<
.v......<..
....#......
.g...#.....
.^...<..#..""",

"""4,0,s
.v..o.+.v
.>.+..#..
v..-..<..
.s..+s-#.
.+.^.+..<
...+...s.
>.s.v.-..
-.->g<-..
.-..^..^.
____.____
""",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_StartButton_pressed():
	var tn = $CanvasLayer/TableList.get_selected_items()[0]
	var str_tmp = table_data[tn].split("\n", true, 1)
	
	# data broken
	if len(str_tmp) < 2: pass
	
	playing_scene = Playing.instance()
	playing_scene.init(CONV.text_to_table(str_tmp[1]), CONV.text_to_stone(str_tmp[0]))
	playing_scene.connect("back_button_pressed", self, "_on_back_button_pressed")
	hide_everything()
	add_child(playing_scene)

func _on_back_button_pressed():
	show_everything()

func hide_everything():
	for n in $CanvasLayer.get_children():
		n.hide()

func show_everything():
	for n in $CanvasLayer.get_children():
		n.show()

