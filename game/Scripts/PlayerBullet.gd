extends KinematicBody2D

var velocity = Vector2()
var damage
var col

func _physics_process(delta):
	col = move_and_collide(velocity * delta)
	if col != null: 
		if col.collider.is_in_group("Enemy"):
			col.collider.harm(damage)
		queue_free()