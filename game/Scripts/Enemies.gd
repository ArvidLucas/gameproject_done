extends Node2D

var active

func _ready():
	active = false

func _body_entered(body):
	if body.is_in_group("Player_Any"):
		active = true