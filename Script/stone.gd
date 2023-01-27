extends Area2D

const CONS = preload("res://Script/constants.gd")
const margin = CONS.STONE_MARGIN

signal animation_ended(stone)
signal stone_flicked(stone, sd)

var type:int
var x:int
var y:int
var size:int

var collision: CollisionPolygon2D
var rect: Polygon2D

func _ready():
	$Timer.wait_time = 1.0 / CONS.FPS
	
	# add a rect
	rect = Polygon2D.new()
	rect.set_polygon(PoolVector2Array([
		Vector2(size*margin, size*margin),
		Vector2(size*(1-margin), size*margin),
		Vector2(size*(1-margin),size*(1-margin)),
		Vector2(size*margin, size*(1-margin))
	]))
	add_child(rect)
	
	# add a colision
	collision = CollisionPolygon2D.new()
	collision.set_polygon(PoolVector2Array([
		Vector2(size*margin, size*margin),
		Vector2(size*(1-margin), size*margin),
		Vector2(size*(1-margin),size*(1-margin)),
		Vector2(size*margin, size*(1-margin))
	]))
	add_child(collision)
	
	draw()

func draw():
	match type:
		CONS.STP.STONE:
			rect.color = CONS.STONE_COLOR
		CONS.STP.DUMMY:
			rect.color = CONS.DUMMY_COLOR
		_:
			assert(0)

func init(_type:int, _x:int, _y:int, _size:int):
	self.type = _type
	self.x = _x
	self.y = _y
	self.size = _size
	self.position = Vector2(x, y) * _size

# move the stone with animation
func move(dir:Vector2):
	var current_position = self.position
	# animation
	for i in range(0, CONS.ONE_STEP_FRAME):
		self.position = current_position + dir * float(size * i) / float(CONS.ONE_STEP_FRAME)
		# wait one frame
		$Timer.start()
		yield($Timer, "timeout")
	
	# change coordinate
	x += int(dir.x)
	y += int(dir.y)
	# fix the position
	self.position = Vector2(x,y) * size
	
	# send the signal to the table
	emit_signal("animation_ended", self)

var mouse_inside:bool = false
var mouse_pressed_position: Vector2
func _on_Stone_input_event(_viewport, event, _shape_idx):
	#if type != CONS.STP.STONE: return
	
	# mouse pressed
	if event is InputEventMouseButton and event.pressed:
		mouse_inside = true
		mouse_pressed_position = event.position
		print(event.position)

func _input(event):
	#if type != CONS.STP.STONE: return
	
	# mouse unpressed
	if mouse_inside and event is InputEventMouseButton and not event.pressed:
		mouse_inside = false
		var diff = event.position - mouse_pressed_position
		emit_signal("stone_flicked", self, give_direction(diff))

func give_direction(vec:Vector2) -> int:
	if vec.length() <= size: return CONS.SD.STOP
	elif abs(vec.angle_to(Vector2.UP   )) < PI/8: return CONS.SD.UP
	elif abs(vec.angle_to(Vector2.DOWN )) < PI/8: return CONS.SD.DOWN
	elif abs(vec.angle_to(Vector2.LEFT )) < PI/8: return CONS.SD.LEFT
	elif abs(vec.angle_to(Vector2.RIGHT)) < PI/8: return CONS.SD.RIGHT
	else: return CONS.SD.STOP
	
