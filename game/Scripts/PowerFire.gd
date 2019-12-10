extends Area2D

export (int) var rate
export (int) var speed

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.fire_rate += rate
		body.bullet_speed += speed
		queue_free()