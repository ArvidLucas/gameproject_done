extends Button

func _pressed():
	get_parent().hide()
	get_tree().paused = false