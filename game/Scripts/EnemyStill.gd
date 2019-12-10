extends KinematicBody2D

signal vect

export (int) var HP
export (int) var speed
export (int) var distance
var vector
var col

func _ready():
	update_HP()

func _physics_process(delta):
	if get_parent().active:
		vector = get_parent().position + position
		vector = get_tree().get_root().get_node("Game").vect_to_player(vector)
		if vector.length() < distance:
			col = move_and_collide(vector.normalized() * speed)
			if col != null and !col.collider.is_in_group("Player_Bullet"):
				if col.collider.is_in_group("Player"):
					col.collider.harm(HP)
				queue_free()

func harm(hurt):
	HP -= hurt
	update_HP()
	if (HP <= 0):
		queue_free()

func update_HP():
	$HUD/Health.text = "HP: " + str(HP)