extends Area2D

export (int) var heal
export (int) var rebound

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.play_powerup_sound()
		body.HP += heal
		body.rebound += rebound
		body.update_HP()
		queue_free()