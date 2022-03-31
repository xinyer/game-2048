extends Control


func _ready():
	$Container/ScoreContainer/BestScore.set_score(Global.get_best_score())

func _on_NewGame_pressed():
	Global.reset()
	$Container/ScoreContainer/CurrentScore.set_score(Global.score)
	$Container/Board.restart()

func _on_Board_game_over():
	$GameOver.show()
	Global.save_best_score()
	$Container/ScoreContainer/BestScore.set_score(Global.get_best_score())


func _on_Board_score():
	$Container/ScoreContainer/CurrentScore.set_score(Global.score)
