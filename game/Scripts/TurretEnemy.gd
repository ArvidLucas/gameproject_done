extends StaticBody2D

signal enemy_shoot

export (int) var HP
export (int) var damage
export (int) var bullet_speed
export (int) var bullet_damage
export (int) var fire_rate
var shoot = 1

func _ready():
	connect("enemy_shoot", get_tree().get_root().get_node("Game"), "_enemy_shoot")

func _physics_process(delta):
	shoot -= delta * fire_rate
	if shoot < 1:
		emit_signal("enemy_shoot", bullet_speed, bullet_damage, position)
		shoot = 1

func harm(hurt):
	HP -= hurt
	if HP <= 0:
		queue_free()