extends StaticBody2D

export (int) var HP
export (int) var damage

func _ready():
	pass

func harm(hurt):
	HP -= hurt
	if (HP <= 0):
		queue_free()