extends Panel

signal game_over
signal game_win
signal score

const SIZE = 4
const tile = preload("res://Scenes/Tile.tscn")

var random = RandomNumberGenerator.new()
var tiles: Array = []
var board: Array = [[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0]]

func _ready():
	random.randomize()
	init_board()
	start()

func start():
	new_tile(2)
	new_tile()
	update_board()

func restart():
	clear_board()
	start()

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
		tiles.push_back(node)
		$Container/Grid.add_child(node)

func update_board():
	for i in range(0, SIZE * SIZE):
		var value = board[floor(i / SIZE)][i % SIZE]
		tiles[i].set_value(value)
	win_game()

func clear_board():
	for i in range(0, SIZE):
		for j in range(0, SIZE):
			board[i][j] = 0

func new_tile(value: int = 0):
	var position = create_random_position()
	var i = value
	if value == 0: i = create_random_value()
	set_element(position, i)
	get_tile(position).play_enter_animation()
	update_board()
	game_over()

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
	if random.randi_range(0, 100) < 70:
		return 2
	else:
		return 4
	
func is_occupied(pos:Vector2) -> bool:
	return get_element(pos) > 0

func get_element(pos:Vector2) -> int:
	return board[pos.x][pos.y]

func set_element(pos: Vector2, value: int):
	board[pos.x][pos.y] = value

func get_tile(pos: Vector2) -> Tile:
	return tiles[pos.x * SIZE + pos.y]

# slide to right, plus two values if same, join once every slide
#
# [0, 0, 2, 0] -> [0, 0, 0, 2]
# [0, 2, 0, 2] -> [0, 0, 0, 4]
# [2, 2, 0, 4] -> [0, 0, 4, 4]
#
func slide(line: Array) -> int:
	var position = -1
	var joined = false
	for _n in range(1, SIZE):
		var i = SIZE - 2
		while i >= 0:
			if line[i + 1] == 0:
				line[i + 1] = line[i]
				line[i] = 0
			elif line[i + 1] == line[i] && !joined:
				line[i + 1] = line[i + 1] * 2
				line[i] = 0
				joined = true
				position = i + 1
				Global.score(line[i + 1])
				$JoinAudioPlayer.play()
				emit_signal("score")
			i -= 1
	return position

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
	var result = [[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0],[0, 0, 0, 0]]
	for i in range(0, SIZE):
		for j in range(0, SIZE):
			result[i][j] = array[j][SIZE - 1 - i]
	return result

func slide_right():
	var before = board.duplicate(true)
	for i in range(0, SIZE):
		var line = board[i]
		var join = slide(line)
		if join >= 0:
			play_join_animation(Vector2(i, join))
	if before != board:
		update_board()
		new_tile()

func slide_left():
	var before = board.duplicate(true)
	for i in range(0, SIZE):
		var line = board[i]
		line.invert()
		var join = slide(line)
		line.invert()
		if join >= 0:
			play_join_animation(Vector2(i, SIZE - 1 -join))
	if before != board:
		update_board()
		new_tile()

func slide_up():
	var before = board.duplicate(true)
	var array = rotate_90_clockwise(board)
	for i in range(0, SIZE):
		var line = array[i]
		var join = slide(line)
		if join >= 0:
			play_join_animation(Vector2(SIZE - 1 - join, i))
	board = rotate_90_counterclockwise(array)
	
	if before != board:
		update_board()
		new_tile()

func slide_down():
	var before = board.duplicate(true)
	var array = rotate_90_clockwise(board)
	for i in range(0, SIZE):
		var line = array[i]
		line.invert()
		var join = slide(line)
		line.invert()
		if join >= 0:
			play_join_animation(Vector2(join, i))
	board = rotate_90_counterclockwise(array)
	if before != board:
		update_board()
		new_tile()

func game_over():
	var isRowOver = true
	# row
	for line in board:
		if line.has(0):
			isRowOver = false
			break
		else:
			for i in range(0, SIZE - 1):
				if line[i] == line[i + 1]:
					isRowOver = false
					break
	# column
	var isColumnOver = true
	for line in rotate_90_clockwise(board):
		if line.has(0):
			isColumnOver = false
			break
		else:
			for i in range(0, SIZE - 1):
				if line[i] == line[i + 1]:
					isColumnOver = false
					break
	if isRowOver || isColumnOver:
		emit_signal("game_over")

func play_join_animation(position: Vector2):
	get_tile(position).play_join_animation()

func win_game():
	for i in range(0, SIZE):
		for j in range(0, SIZE):
			if board[i][j] == Global.WIN:
				emit_signal("game_win")
				break
	pass

func _on_SwipeDetector_swiped(direction):
	if direction == Vector2(1, 0):
		slide_left()
	elif direction == Vector2(-1, 0):
		slide_right()
	elif direction == Vector2(0, 1):
		slide_up()
	elif direction == Vector2(0, -1):
		slide_down()
