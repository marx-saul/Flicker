extends Node2D

const CONS = preload("res://Script/constants.gd")
const Ground = preload("res://Scene/Ground.tscn")
const Stone = preload("res://Scene/Stone.tscn")

signal table_step_added
signal table_cleared

# the size of one space
var size: int = 40

# table objects
var table = []
var stone_num:int = 0

# for stone flicking
var is_stone_moving:bool = false

func init(table_data, stones_data):
	is_stone_moving = false
	table = []
	for n in get_children():
		n.queue_free()	
	draw(table_data, stones_data)
	stone_num = len(stones_data)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func draw(table_data, stones_data):
	draw_table(table_data)
	draw_stones(stones_data)

# set the table
func draw_table(data):
	var y = 0
	for row in data:
		var result_row = []
		var x = 0
		for type in row:
			var ground = Ground.instance()
			ground.init(type, x, y, size)
			add_child(ground)
			result_row.append(ground)
			x += 1
		table.append(result_row)
		y += 1

# set the stones
func draw_stones(data):
	for info in data:
		var x = info[0]
		var y = info[1]
		var type = info[2]
		
		# create a stone
		var stone = Stone.instance()
		stone.init(type, x, y, size)
		stone.connect("animation_ended", self, "_on_animation_ended")
		stone.connect("stone_flicked", self, "_on_stone_flicked")
		add_child(stone)
		
		# set stones
		table[y][x].stone = stone
		table[y][x].on_stone = true

###############################################

var _move_sd:int = CONS.SD.STOP

func move(stone):
	assert(stone != null)
	
	# stop
	if _move_sd == CONS.SD.STOP:
		stop()
		return
	
	var x = stone.x
	var y = stone.y
	var dir = CONS.sd_to_dir(_move_sd)
	var to_x: int = x + dir.x
	var to_y: int = y + dir.y
	
	# going out of the table
	if to_y < 0 or to_y >= len(table) or to_x < 0 or to_x >= len(table[to_y]):
		stop()
		return
	
	var to_ground = table[to_y][to_x]
	# check if stone hits to another stone
	if to_ground.on_stone:
		move(to_ground.stone)
		return
	
	move_one_step(stone, x, y, dir, to_x, to_y)

# move for a direction (false : move success, true : move failiure)
func move_one_step(stone, x:int, y:int, dir:Vector2, to_x:int, to_y:int):
	var to_ground = table[to_y][to_x]
	var ground = table[y][x]
	
	match to_ground.type:
		CONS.GTP.ROOT:
			stone.move(dir)
		
		CONS.GTP.STICK, CONS.GTP.GOAL:
			stone.move(dir)
			_move_sd = CONS.SD.STOP
		
		# stop
		CONS.GTP.VOID, CONS.GTP.WALL:
			stop()
			return
		
		# change direction
		CONS.GTP.UP:
			stone.move(dir)
			_move_sd = CONS.SD.UP
		CONS.GTP.DOWN:
			stone.move(dir)
			_move_sd = CONS.SD.DOWN
		CONS.GTP.LEFT:
			stone.move(dir)
			_move_sd = CONS.SD.LEFT
		CONS.GTP.RIGHT:
			stone.move(dir)
			_move_sd = CONS.SD.RIGHT
		
		# rotate
		CONS.GTP.ROTATE_POS:
			stone.move(dir)
			rotate_directions(true)
		CONS.GTP.ROTATE_NEG:
			stone.move(dir)
			rotate_directions(false)
			
		_:
			stop()
			return
	
	# move on the ground
	ground.on_stone = false
	to_ground.stone = stone
	to_ground.on_stone = true
	
# for convenience
func stop():
	_move_sd = CONS.SD.STOP
	is_stone_moving = false

const rot_pos = {
	CONS.GTP.RIGHT: CONS.GTP.UP,
	CONS.GTP.UP:    CONS.GTP.LEFT,
	CONS.GTP.LEFT:  CONS.GTP.DOWN,
	CONS.GTP.DOWN:  CONS.GTP.RIGHT,
}
const rot_neg = {
	CONS.GTP.UP:    CONS.GTP.RIGHT,
	CONS.GTP.LEFT:  CONS.GTP.UP,
	CONS.GTP.DOWN:  CONS.GTP.LEFT,
	CONS.GTP.RIGHT: CONS.GTP.DOWN,
}
# rotate directtions
func rotate_directions(pos: bool):
	var rot
	if pos: rot = rot_pos
	else:   rot = rot_neg
	
	for row in table: for ground in row:
		match ground.type:
			CONS.GTP.RIGHT, CONS.GTP.UP, CONS.GTP.LEFT, CONS.GTP.DOWN:
				ground.type = rot[ground.type]
				ground.draw()

# for signals
func _on_animation_ended(stone):
	# check if goaled
	var x = stone.x
	var y = stone.y
	var ground = table[y][x]
	if ground.type == CONS.GTP.GOAL and stone.type == CONS.STP.STONE:
		# get rid of the stone
		stone.hide()
		stone_num -= 1
		ground.on_stone = false
	# table cleared
	if stone_num <= 0: 
		emit_signal("table_cleared")
	
	move(stone)

# flick a stone
func flick(stone, sd:int):
	# not allowing to flick while stones are moving
	if is_stone_moving: return
	
	emit_signal("table_step_added")
	is_stone_moving = true
	_move_sd = sd
	move(stone)

func _on_stone_flicked(stone, sd):
	flick(stone, sd)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

