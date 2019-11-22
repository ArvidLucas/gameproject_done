extends KinematicBody2D

var velocity = Vector2()
var damage

func _physics_process(delta):
	move_and_collide(velocity * delta)

func hit(body):
	if body.is_in_group("Enemy"):
		body.harm(damage)
		queue_free()