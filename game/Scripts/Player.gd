extends KinematicBody2D

signal player_shoot
signal die

export (int) var HP
export (int) var speed
export (int) var drag
export (int) var bullet_speed
export (int) var bullet_damage
export (int) var fire_rate
export (int) var rebound
var input = Vector2()
var velocity = Vector2()
var unitvel = Vector2()
var inv = 0
var shoot = 1

func _ready():
#warning-ignore:return_value_discarded
	connect("player_shoot", get_tree().get_root().get_node("Game"), "_player_shoot")
	connect("die", get_tree().get_root().get_node("Game"), "_player_die")
	update_HP()

func _process(delta):
	if Input.is_action_pressed("player_right") and not Input.is_action_pressed("player_left"):
		input.x = speed
	elif Input.is_action_pressed("player_left") and not Input.is_action_pressed("player_right"):
		input.x = -speed
	else:
		input.x = 0
	if Input.is_action_pressed("player_up") and not Input.is_action_pressed("player_down"):
		input.y = -speed
	elif Input.is_action_pressed("player_down") and not Input.is_action_pressed("player_up"):
		input.y = speed
	else:
		input.y = 0
	if shoot >= 1 and Input.is_action_pressed("player_shoot"):
		$Fire.play()
		emit_signal("player_shoot", bullet_speed, bullet_damage)
		shoot = 0
	elif shoot < 1:
		shoot += delta * fire_rate

func _physics_process(delta):
	if HP > 0:
		velocity += input
		velocity /= drag
#warning-ignore:return_value_discarded
		move_and_slide(velocity * delta)
		unitvel = velocity.normalized()
		$Shape.set_rotation(get_angle_to(position + unitvel) + PI/2)
		if inv > 0:
			inv -= delta * 4
			if inv < 0:
				inv = 0
		for i in range(rebound * 4 + 2, -1, -1):
			match i % 2:
				0:
					if 4 * inv > i:
						$Shape/Sprite.show()
						break
				1:
					if 4 * inv > i:
						$Shape/Sprite.hide()
						break

func harm(hurt):
	if !inv:
		$Hit.play()
		HP -= hurt
		update_HP()
		inv = rebound
		if HP <= 0:
			emit_signal("die")

func update_HP():
	$HUD/Health.text = "HP: " + str(HP)

func play_powerup_sound():
	$Powerup.play()