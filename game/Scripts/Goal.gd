extends Area2D

func _ready():
	connect("body_entered", get_tree().get_root().get_node("Game"), "_goal_entered")