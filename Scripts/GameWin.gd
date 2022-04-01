extends Popup

signal restart

func _on_RestartButton_pressed():
	hide()
	emit_signal("restart")

func _on_RestartTimer_timeout():
	$RestartButton.visible = true
