extends KinematicBody2D

signal die

export (int) var HP
export (int) var speed
export (int) var distance
var move = false
var vector
var col

func _ready():
	connect("die", get_tree().get_root().get_node("Game"), "_play_death_sound")
	update_HP()

func _physics_process(delta):
	if get_parent().active:
		vector = get_parent().position + position
		vector = get_tree().get_root().get_node("Game").vect_to_player(vector)
		if vector.length() < distance:
			if !move:
				$Move.play()
				move = true
			col = move_and_collide(vector.normalized() * speed)
			if col != null and !col.collider.is_in_group("Player_Bullet"):
				if col.collider.is_in_group("Player"):
					col.collider.harm(HP)
				emit_signal("die")
				queue_free()
		else:
			if move:
				$Move.stop()
				move = false

func harm(hurt):
	$Hit.play()
	HP -= hurt
	update_HP()
	if (HP <= 0):
		emit_signal("die")
		queue_free()

func update_HP():
	$HUD/Health.text = "HP: " + str(HP)