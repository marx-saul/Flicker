extends Node

enum GTP {
	# you can pass freely
	ROOT = 0,
	
	# you can pass but you stop
	STICK,
	
	# cannot enter
	VOID,
	WALL,
	
	# change the direction
	UP,
	DOWN,
	LEFT,
	RIGHT,
	
	# rotate the direction
	ROTATE_POS,
	ROTATE_NEG,
	
	# need to pass these tiles at least once
	HAVENT_PASSED,
	ALREADY_PASSED,
	
	# if every pass-tiles is passed, walls will be roots once and for all
	PASS_WALL
	
	# a stone must be on these tiles
	SWITCH_OFF,
	SWITCH_ON,
	
	# if every switch is on, walls will be roots once and for all
	SWITCH_WALL,
	
	# goal if you pass it
	GOAL,
	
}
const GROUND_BASE_COLOR = Color("41e636")
const GROUND_ARROW_COLOR = Color("8a6cee")
const GROUND_ROTATE_COLOR = Color("ffffff")

enum STP {
	STONE = 0,
	DUMMY = 1,
}
const STONE_COLOR = Color(231.0/256.0, 53.0/256.0,  149.0/256.0, 0.7)
const DUMMY_COLOR = Color(168.0/256.0, 168.0/256.0, 168.0/256.0, 0.7)
enum SD {
	STOP = 0,
	UP = 1,
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4,
}
const STONE_MARGIN = 0.1
static func sd_to_dir(sd: int) -> Vector2:
	match sd:
		SD.STOP:  return Vector2(0,0)
		SD.UP:    return Vector2(0, -1)
		SD.DOWN:  return Vector2(0, 1)
		SD.LEFT:  return Vector2(-1, 0)
		SD.RIGHT: return Vector2(1, 0)
		_:
			assert(0)
			return Vector2(0,0)

const TABLE_WIDTH_MARGIN = 10

const ONE_STEP_FRAME = 10
const FPS = 60
