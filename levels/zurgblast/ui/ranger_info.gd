class_name RangerInfo extends GameInfo

static var COLORS := [
	Color.WHITE,
	Color.RED,
	Color.ORANGE,
	Color.YELLOW,
	Color.LIME_GREEN,
	Color.BLUE,
	Color.VIOLET,
]

var color: Color = COLORS[0]


func _init(a_color: Color = Color.WHITE):
	color = a_color


func _to_string():
	return "Ranger Color %s" % color
