extends KinematicBody2D

var velocity = Vector2()

func _physics_process(delta):
#warning-ignore:return_value_discarded
	move_and_collide(velocity * delta)