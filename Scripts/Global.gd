extends Node

var score: int = 0
var FILE = "user://data.res"

func score(value: int):
	score += value

func save_best_score():
	if score > get_best_score():
		var data = Data.new()
		data.best_score = score
		ResourceSaver.save(FILE, data)

func get_best_score() -> int:
	if ResourceLoader.exists(FILE):
		var data = ResourceLoader.load(FILE)
		if data is Data:
			return data.best_score
	return 0
	
func reset():
	score = 0
