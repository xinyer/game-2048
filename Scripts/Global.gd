extends Node

var score: int = 0

func score(value: int):
	score += value
	
func reset():
	score = 0
