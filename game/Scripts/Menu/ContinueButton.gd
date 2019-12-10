extends Button

func _pressed():
	ProjectSettings.set("load", true)
	get_tree().change_scene("res://Game/Game.tscn")