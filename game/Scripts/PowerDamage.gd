extends Area2D

export (int) var damage
export (int) var rate
export (int) var speed

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.bullet_damage += damage
		if (body.bullet_speed > speed):
			body.bullet_speed += speed
		if (body.fire_rate > rate):
			body.fire_rate += rate
		queue_free()