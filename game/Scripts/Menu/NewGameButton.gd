extends Button

func _pressed():
	ProjectSettings.set("load", false)
	get_tree().change_scene("res://Game/Game.tscn")