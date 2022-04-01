extends Popup

signal start_again


func _ready():
	pass

func _on_StartAgainButton_pressed():
	hide()
	emit_signal("start_again")
