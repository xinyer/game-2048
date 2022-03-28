extends ColorRect

const width = 4
const height = 4

const tile = preload("res://Tile.tscn")

var nodes:Array = []

func _ready():
	init_board()
	
func init_board():
	for n in range(0, width * height):
		var node = tile.instance()
		node.setValue(10)
		nodes.push_front(node)
		$Container/Grid.add_child(node)
