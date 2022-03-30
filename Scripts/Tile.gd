extends Control

var defaultColor: Color = Color("#eee4da")

func _ready():
#	$TextContainer/Label.text = ""
#	$Background.color = defaultColor
	pass
	
func set_value(value: int) -> void:
	if (value == 0):
		$TextContainer/Label.text = ""
#		$Background.color = defaultColor
	else:
		$TextContainer/Label.text = str(value)
#		$TextContainer/Label.get_font("font").size = 24
		# TODO: change color by the value
