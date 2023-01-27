extends Node2D

const CONS = preload("res://Script/constants.gd")
const CONV = preload("res://Script/convert.gd")
const Stone = preload("res://Scene/Stone.tscn")

signal back_button_pressed

var table_data = CONV.text_to_table(
"""
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
""")

var stone_data = [
	[4, 1, CONS.STP.STONE]
]
var step_num:int

func init(var td, var sd):
	table_data = td
	stone_data = sd

func _ready():
	$Table.connect("table_cleared", self, "_on_table_cleared")
	$Table.connect("table_step_added", self, "_on_table_step_added")
	
	# set table size and align at center
	var column: int = len(table_data)
	var row: int = 0
	for r in table_data:
		row = max(row, len(r))
	if column == 0 or row == 0: return
	
	var table_width:  int = get_viewport_rect().size.x - 2*CONS.TABLE_WIDTH_MARGIN
	var table_height: int = get_viewport_rect().size.y - $Table.position.y
	
	$Table.size = min(table_height / column, table_width / row)
	$Table.position.y += (table_height - $Table.size * column) / 2
	$Table.position.x  = (table_width  - $Table.size * row   ) / 2 + CONS.TABLE_WIDTH_MARGIN
	
	$Table.init(table_data, stone_data)

func _on_table_cleared():
	$CanvasLayer/ClearLabel.show()

func _on_table_step_added():
	step_num += 1
	$CanvasLayer/StepLabel.set_text("STEP: " + String(step_num))
	
func _on_ResetButton_pressed():
	$Table.init(table_data, stone_data)
	step_num = 0
	$CanvasLayer/StepLabel.set_text("STEP: 0")
	$CanvasLayer/ClearLabel.hide()

func _on_BackButton_pressed():
	queue_free()
	emit_signal("back_button_pressed")
