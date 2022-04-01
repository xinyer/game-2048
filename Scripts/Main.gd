extends Control


func _ready():
	$Container/ScoreContainer/BestScore.set_score(Global.get_best_score())

func start_game():
	Global.reset()
	$Container/ScoreContainer/CurrentScore.set_score(Global.score)
	$Container/Board.restart()


func _on_NewGame_pressed():
	start_game()

func _on_Board_game_over():
	$GameOver.show()
	Global.save_best_score()
	$Container/ScoreContainer/BestScore.set_score(Global.get_best_score())

func _on_Board_game_win():
	$GameWin.show()

func _on_Board_score():
	$Container/ScoreContainer/CurrentScore.set_score(Global.score)

func _on_GameOver_start_again():
	start_game()

func _on_GameWin_restart():
	start_game()

