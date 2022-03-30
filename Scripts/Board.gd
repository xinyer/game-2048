extends ColorRect

const SIZE = 4
const tile = preload("res://Tile.tscn")

var random = RandomNumberGenerator.new()
var tiles: Array = []
var board: Array = [[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0]]

func _ready():
	random.randomize()
	init_board()
	new_tile(2)
	new_tile()
	update_board()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		slide_left()
	elif Input.is_action_just_pressed("ui_right"):
		slide_right()
	elif Input.is_action_just_pressed("ui_up"):
		slide_up()
	elif Input.is_action_just_pressed("ui_down"):
		slide_down()
	
func init_board():
	for _n in range(0, SIZE * SIZE):
		var node = tile.instance()
		node.set_value(0)
		tiles.push_back(node)
		$Container/Grid.add_child(node)

func update_board():
	for i in range(0, SIZE * SIZE):
		var value = board[floor(i / SIZE)][i % SIZE]
		tiles[i].set_value(value)
	
func new_tile(value: int = 0):
	var position = create_random_position()
	var i = value
	if value == 0:
		i = create_random_value()
	set_element(position, i)
	update_board()
	
func create_random_position() -> Vector2:
	var position = Vector2(
		random.randi_range(0, SIZE - 1),
		random.randi_range(0, SIZE - 1)
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

# slide to right, plus two values if same
#
# [0, 0, 2, 0] -> [0, 0, 0, 2]
# [0, 2, 0, 2] -> [0, 0, 0, 4]
#
func slide(line: Array):
	for _n in range(1, SIZE):
		var i = SIZE - 2
		while i >= 0:
			if line[i + 1] == 0:
				line[i + 1] = line[i]
				line[i] = 0
			elif line[i + 1] == line[i]:
				line[i + 1] = line[i + 1] * 2
				line[i] = 0
			i = i - 1

# rotate 90 degrees clockwise
#
#	[ 0, 1, 2, 3]
#	[ 4, 5, 6, 7]
#	[ 8, 9,10,11]
#	[12,13,14,15]
# to
#	[12, 8, 4, 0]
#	[13, 9, 5, 1]
#	[14,10, 6, 2]
#	[15,11, 7, 3]
#
func rotate_90_clockwise(array: Array) -> Array:
	var result = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
	for i in range(0, SIZE):
		for j in range(0, SIZE):
			result[i][j] = array[SIZE - 1 -j][i]
	return result

# rotate 90 degrees counterclockwise
#
#	[ 0, 1, 2, 3]
#	[ 4, 5, 6, 7]
#	[ 8, 9,10,11]
#	[12,13,14,15]
# to
#	[3, 7,11,15]
#	[2, 6,10,14]
#	[1, 5, 9,13]
#	[0, 4, 8,12]
#
func rotate_90_counterclockwise(array: Array) -> Array:
	var result = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
	for i in range(0, SIZE):
		for j in range(0, SIZE):
			result[i][j] = array[j][SIZE - 1 - i]
	return result
	
func slide_right():
	var before = board.duplicate(true)
	for line in board:
		slide(line)
	if before != board:
		update_board()
		new_tile()

func slide_left():
	var before = board.duplicate(true)
	for line in board:
		line.invert()
		slide(line)
		line.invert()
	if before != board:
		update_board()
		new_tile()

func slide_up():
	var before = board.duplicate(true)
	var array = rotate_90_clockwise(board)
	for line in array:
		slide(line)
	board = rotate_90_counterclockwise(array)
	if before != board:
		update_board()
		new_tile()
	
func slide_down():
	var before = board.duplicate(true)
	var array = rotate_90_clockwise(board)
	for line in array:
		line.invert()
		slide(line)
		line.invert()
	board = rotate_90_counterclockwise(array)
	if before != board:
		update_board()
		new_tile()
