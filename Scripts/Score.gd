extends PanelContainer

export var title: String = "Title"
export var score: int = 0

func _ready():
	$VBoxContainer/Title.text = title
	$VBoxContainer/Score.text = str(score)

func set_score(score: int):
	$VBoxContainer/Score.text = str(score)
