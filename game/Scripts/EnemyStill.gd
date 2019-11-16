extends StaticBody2D

export (int) var HP

func _ready():
	pass

func damage(hurt):
	HP -= hurt
	if (HP <= 0):
		queue_free()