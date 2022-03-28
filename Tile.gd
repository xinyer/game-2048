extends Control

var defaultColor: Color = Color(205, 193, 180)

func _ready():
	$TextContainer/Label.text = ""
	$Background.color = defaultColor
	
func setValue(value: int):
	if (value == 0):
		$TextContainer/Label.text = ""
		$Background.color = defaultColor
	else:
		$TextContainer/Label.text = str(value)
		# TODO: change color by the value
