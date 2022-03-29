extends ColorRect

const width = 4
const height = 4

const tile = preload("res://Tile.tscn")
var random = RandomNumberGenerator.new()
var nodes: Array = []
var board: Array = [
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0]
]

func _ready():
	random.randomize()
	init_board()
	new_tile(2)
	new_tile()
	update_board()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		for line in board:
			line.invert()
			slide(line)
			line.invert()
		update_board()
		new_tile()
		pass
	elif Input.is_action_just_pressed("ui_right"):
		for line in board:
			slide(line)
		update_board()
		new_tile()	
	elif Input.is_action_just_pressed("ui_up"):
		pass
	elif Input.is_action_just_pressed("ui_down"):
		pass	
	
func init_board():
	for n in range(0, width * height):
		var node = tile.instance()
		node.set_value(0)
		nodes.push_back(node)
		$Container/Grid.add_child(node)

func update_board():
	for i in range(0, width * height):
		nodes[i].set_value(board[floor(i / width)][i % height])
	
func new_tile(value: int = 0):
	var position = create_random_position()
	var i = value
	if value == 0: i = create_random_value()
	set_element(position, i)
	update_board()
	
func create_random_position() -> Vector2:
	var position = Vector2(
		random.randi_range(0, width - 1),
		random.randi_range(0, height - 1)
	)
	while(is_occupied(position)):
		position = create_random_position()
		pass
	return position

func create_random_value():
	if random.randi_range(0, 100) > 50:
		return 2
	else:
		return 4
	
func is_occupied(pos:Vector2) -> bool:
	return get_element(pos) > 0

func get_element(pos:Vector2) -> int:
	return board[pos.x][pos.y]

func set_element(pos: Vector2, value: int):
	board[pos.x][pos.y] = value
	
func slide(line: Array):
	for n in range(1, 4):
		var i = width - 2
		while i >= 0:
			if line[i + 1] == 0:
				line[i + 1] = line[i]
				line[i] = 0
			elif line[i + 1] == line[i]:
				line[i + 1] = line[i + 1] * 2
				line[i] = 0
			i = i - 1
