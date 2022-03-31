extends Control


func _ready():
	pass

func _on_NewGame_pressed():
	pass

func _on_Board_game_over():
	$GameOver.show()


func _on_Board_score():
	$Container/ScoreContainer/CurrentScore.set_score(Global.score)
