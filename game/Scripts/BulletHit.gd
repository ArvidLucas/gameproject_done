extends Area2D

func _ready():
	connect("body_entered", get_parent(), "hit")