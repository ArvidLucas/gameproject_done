extends Node2D

var active

func _ready():
	active = false

func _body_entered(body):
	if body.is_in_group("Player"):
		active = true
	if body.is_in_group("Player_Bullet") and !active:
		body.queue_free()