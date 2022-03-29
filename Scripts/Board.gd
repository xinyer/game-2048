extends ColorRect

const width = 4
const height = 4

const empty = [[0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0]]

const tile = preload("res://Tile.tscn")
var random = RandomNumberGenerator.new()
var nodes: Array = []
var board: Array

func _ready():
	board = empty.duplicate(true)
	random.randomize()
	init_board()
	new_tile()
	update_board()
	
func init_board():
	for n in range(0, width * height):
		var node = tile.instance()
		node.set_value(0)
		nodes.push_front(node)
		$Container/Grid.add_child(node)

func update_board():
	for i in range(0, width * height):
		nodes[width * height - (i + 1)].set_value(board[floor(i / width)][i % height])
	pass
	
func new_tile():
	var position = create_random_position()
	while(is_occupied(position)):
		position = create_random_position()
		pass
	set_element(position, 2)
	
func create_random_position() -> Vector2:
	return Vector2(
		random.randi_range(0, width - 1),
		random.randi_range(0, height - 1)
	)
	
func is_occupied(pos:Vector2) -> bool:
	return get_element(pos) > 0

func get_element(pos:Vector2) -> int:
	return board[pos.x][pos.y]

func set_element(pos: Vector2, value: int):
	board[pos.x][pos.y] = value
