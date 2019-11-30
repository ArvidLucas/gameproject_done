extends Area2D

export (int) var power

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.damage += power
		queue_free()