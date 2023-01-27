extends Node2D

const CONS = preload("res://Script/constants.gd")

var type:int
var x:int
var y:int
var size:int
# the stone which is on this ground
var stone: Object
var on_stone: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	draw()

# change type
func change(_type:int):
	self.type = _type
	draw()
	
# visualize the ground
func draw():
	# clear
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
	
	# draw nothing
	if self.type == CONS.GTP.VOID: return
	
	# make border
	var border = Line2D.new()
	border.add_point(Vector2(0, 0))
	border.add_point(Vector2(size, 0))
	border.add_point(Vector2(size, size))
	border.add_point(Vector2(0, size))
	border.add_point(Vector2(0, 0))
	border.default_color = CONS.GROUND_BASE_COLOR
	border.width = 1
	add_child(border)
	
	# visualize
	match self.type:
		CONS.GTP.ROOT:
			pass
			
		CONS.GTP.STICK:
			# add a rect
			var rect = Polygon2D.new()
			rect.set_polygon(PoolVector2Array([
				Vector2(0, 0),
				Vector2(size, 0),
				Vector2(size, size),
				Vector2(0, size)
			]))
			rect.color = CONS.GROUND_BASE_COLOR
			rect.color.a = 0.3
			add_child(rect)
			
		CONS.GTP.WALL:
			var inner = Polygon2D.new()
			inner.set_polygon(PoolVector2Array([
				Vector2(0, 0),
				Vector2(size, 0),
				Vector2(size, size),
				Vector2(0, size)
			]))
			inner.color = CONS.GROUND_BASE_COLOR
			add_child(inner)
			
		CONS.GTP.UP:
			var arrow = Line2D.new()
			arrow.width = 5
			arrow.add_point(Vector2(float(size)/2, size - arrow.width))
			arrow.add_point(Vector2(float(size)/2, arrow.width))
			arrow.add_point(Vector2(arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, arrow.width))
			arrow.add_point(Vector2(size - arrow.width, float(size)/2))
			arrow.default_color = CONS.GROUND_ARROW_COLOR
			add_child(arrow)
		CONS.GTP.DOWN:
			var arrow = Line2D.new()
			arrow.width = 5
			arrow.add_point(Vector2(float(size)/2, arrow.width))
			arrow.add_point(Vector2(float(size)/2, size - arrow.width))
			arrow.add_point(Vector2(arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, size - arrow.width))
			arrow.add_point(Vector2(size - arrow.width, float(size)/2))
			arrow.default_color = CONS.GROUND_ARROW_COLOR
			add_child(arrow)
		CONS.GTP.LEFT:
			var arrow = Line2D.new()
			arrow.width = 5
			arrow.add_point(Vector2(size - arrow.width, float(size)/2))
			arrow.add_point(Vector2(arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, arrow.width))
			arrow.add_point(Vector2(arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, size - arrow.width))
			arrow.default_color = CONS.GROUND_ARROW_COLOR
			add_child(arrow)
		CONS.GTP.RIGHT:
			var arrow = Line2D.new()
			arrow.width = 5
			arrow.add_point(Vector2(arrow.width, float(size)/2))
			arrow.add_point(Vector2(size - arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, arrow.width))
			arrow.add_point(Vector2(size - arrow.width, float(size)/2))
			arrow.add_point(Vector2(float(size)/2, size - arrow.width))
			arrow.default_color = CONS.GROUND_ARROW_COLOR
			add_child(arrow)
		
		CONS.GTP.ROTATE_POS, CONS.GTP.ROTATE_NEG:
			# draw a circle
			var circ = Line2D.new()
			circ.width = 1
			circ.default_color = CONS.GROUND_ROTATE_COLOR
			var pol = 20
			var rat = 0.75
			for i in range(0, pol + 1):
				circ.add_point(Vector2(1 + rat*cos(2*PI*i/pol), 1 + rat*sin(2*PI*i/pol)) * size/2)
			add_child(circ)
			
			# draw an arrow
			var arr = Line2D.new()
			arr.width = 1
			arr.default_color = CONS.GROUND_ROTATE_COLOR
			var pt = Vector2(1 + rat, 1) * size/2
			arr.add_point(pt)
			if self.type == CONS.GTP.ROTATE_POS:
				arr.add_point(pt - Vector2(cos(-PI/4), sin(-PI/4)) * (1-rat) * size/2)
			else:
				arr.add_point(pt + Vector2(cos(-PI/4), sin(-PI/4)) * (1-rat) * size/2)
			arr.add_point(pt)
			if self.type == CONS.GTP.ROTATE_POS:
				arr.add_point(pt - Vector2(cos(-3*PI/4), sin(-3*PI/4)) * (1-rat) * size/2)
			else:
				arr.add_point(pt + Vector2(cos(-3*PI/4), sin(-3*PI/4)) * (1-rat) * size/2)
			add_child(arr)
		
		CONS.GTP.GOAL:
			var label = Label.new()
			label.text = "GOAL"
			label.align = Label.ALIGN_CENTER
			label.valign = Label.ALIGN_CENTER
			label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			label.set_size(Vector2(size, size))
			add_child(label)
		_:
			print("others")

func init(_type:int, _x:int, _y:int, _size:int):
	self.type = _type
	self.x = _x
	self.y = _y
	self.size = _size
	self.position = Vector2(x, y) * _size

