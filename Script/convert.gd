extends Node

const CONS = preload("res://Script/constants.gd")

const char_to_gtp = {
	"o" : CONS.GTP.ROOT, # for convenience
	"." : CONS.GTP.ROOT,
	"s" : CONS.GTP.STICK,
	"_" : CONS.GTP.VOID,
	"#" : CONS.GTP.WALL,
	"^" : CONS.GTP.UP,
	"v" : CONS.GTP.DOWN,
	"<" : CONS.GTP.LEFT,
	">" : CONS.GTP.RIGHT,
	"+" : CONS.GTP.ROTATE_POS,
	"-" : CONS.GTP.ROTATE_NEG,
	"?" : CONS.GTP.HAVENT_PASSED,
	"!" : CONS.GTP.ALREADY_PASSED,
	"$" : CONS.GTP.PASS_WALL,
	"0" : CONS.GTP.SWITCH_OFF,
	"1" : CONS.GTP.SWITCH_ON,
	"%" : CONS.GTP.SWITCH_WALL,
	"g" : CONS.GTP.GOAL,
}

const gtp_to_char = {
	CONS.GTP.ROOT : ".",
	CONS.GTP.STICK : "s",
	CONS.GTP.VOID : "_",
	CONS.GTP.WALL : "#",
	CONS.GTP.UP : "^",
	CONS.GTP.DOWN : "v",
	CONS.GTP.LEFT : "<",
	CONS.GTP.RIGHT : ">",
	CONS.GTP.ROTATE_POS: "+",
	CONS.GTP.ROTATE_NEG: "-",
	CONS.GTP.HAVENT_PASSED : "?",
	CONS.GTP.ALREADY_PASSED : "!",
	CONS.GTP.PASS_WALL : "$",
	CONS.GTP.SWITCH_OFF : "0",
	CONS.GTP.SWITCH_ON : "1",
	CONS.GTP.SWITCH_WALL : "%",
	CONS.GTP.GOAL : "g",
}

const char_to_stp = {
	"s" : CONS.STP.STONE,
	"d" : CONS.STP.DUMMY,
}


static func table_to_text(data) -> String:
	var result = ""
	for row in data:
		for tp in data: result += gtp_to_char[tp]
		result += "\n"
	return result

static func text_to_table(text:String):
	var result = []
	for text_row in text.split("\n", true):
		var result_row = []
		while text_row.length() > 0:
			# data broken
			if not text_row.substr(0, 1) in char_to_gtp: continue
			
			result_row.append(char_to_gtp[text_row.substr(0, 1)])
			text_row = text_row.substr(1)
		result.append(result_row)
	return result


static func text_to_stone(text:String):
	var result = []
	for st in text.split("/", true):
		var xytp = st.split(",")
		# data broken
		if len(xytp) < 3: continue
		if not xytp[2] in char_to_stp: continue
		
		result.append([int(xytp[0]), int(xytp[1]), char_to_stp[xytp[2]]])
	return result
