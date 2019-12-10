extends Area2D

export (int) var player_boost
export (int) var bullet_boost

func _ready():
	connect("body_entered", self, "_body_entered")

func _body_entered(body):
	if body.is_in_group("Player"):
		body.speed += player_boost
		body.bullet_speed += bullet_boost
		queue_free()