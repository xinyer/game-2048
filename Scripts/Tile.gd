extends Control

class_name Tile

const COLORS = {
	0:"#cdc1b4",    2:"#eee4da",    4:"#ede0c8",     8:"#f2b179",
	16:"#f59563",   32:"#f67c5f",   64:"#f65e3b",    128:"#edcf72",
	256:"#edcc61",  512:"#edc850",  1024:"#ecc440",  2048:"#edc02e",
	4096:"#ff3d3d", 8192:"#ff1e20", 16384:"#ea4241", 32768:"##74b1dc",
	65536:"#60a0e6"
}

var style = StyleBoxFlat.new()

func _ready():
	style.set_bg_color(COLORS[0])
	style.set_corner_radius_all(4)
	$Panel.set('custom_styles/panel', style)
	pass
	
func set_value(value: int) -> void:
	set_bg_color(value)
	set_text_color(value)
	if (value == 0):
		$TextContainer/Label.text = ""
	else:
		$TextContainer/Label.text = str(value)
#		$TextContainer/Label.get_font("font").size = 24
		# TODO: change color by the value

func set_bg_color(value: int):
	var color = COLORS[value]
	style.set_bg_color(color)
	$Panel.set('custom_styles/panel', style)

func set_text_color(value: int):
	if value >= 8:
		$TextContainer/Label.set("custom_colors/font_color", Color.white)
	else:
		$TextContainer/Label.set("custom_colors/font_color", Color("#776e65"))

func play_enter_animation():
	$AnimationPlayer.play("Enter")
