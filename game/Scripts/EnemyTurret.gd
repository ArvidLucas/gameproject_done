extends StaticBody2D

signal shoot
signal orient

export (int) var HP
export (int) var bullet_speed
export (int) var bullet_damage
export (int) var fire_rate
export (int) var bullet_count
export (float) var bullet_spread
var shoot = 0

func _ready():
	connect("shoot", get_tree().get_root().get_node("Game"), "_enemy_shoot")
	connect("orient", get_tree().get_root().get_node("Game"), "_enemy_orient")
	bullet_count -= 1
	bullet_spread = deg2rad(bullet_spread)
	update_HP()

func _process(delta):
	if get_parent().active:
		emit_signal("orient", self, get_parent().position + position)

func _physics_process(delta):
	if get_parent().active:
		shoot += delta * fire_rate
	if shoot >= 1:
		emit_signal("shoot", bullet_speed, bullet_damage, get_parent().position + position, bullet_count, bullet_spread)
		shoot = 0

func harm(hurt):
	HP -= hurt
	update_HP()
	if HP <= 0:
		queue_free()

func update_HP():
	$HUD/Health.text = "HP: " + str(HP)

func orientate(theta):
	$Shape.set_rotation(theta + PI/2)