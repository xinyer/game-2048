extends Control

var defaultColor: Color = Color(205, 193, 180)

func _ready():
#	$TextContainer/Label.text = ""
#	$Background.color = defaultColor
	pass
	
func setValue(value: int) -> void:
	print("set value:" + str(value))
	if (value == 0):
		$TextContainer/Label.text = ""
#		$Background.color = defaultColor
	else:
		$TextContainer/Label.text = str(value)
		# TODO: change color by the value
