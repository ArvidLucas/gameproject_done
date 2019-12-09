extends KinematicBody2D

signal player_shoot

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
		emit_signal("player_shoot", bullet_speed, bullet_damage)
		shoot = 0
	elif shoot < 1:
		shoot += delta * fire_rate
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta):
	if HP > 0:
		velocity += input
		velocity /= drag
#warning-ignore:return_value_discarded
		move_and_slide(velocity * delta)
		unitvel = velocity.normalized()
		if unitvel.y > 0:
			set_rotation(atan(-unitvel.x / unitvel.y) + PI)
		elif unitvel.y < 0:
			set_rotation(atan(-unitvel.x / unitvel.y))
		else:
			set_rotation(unitvel.x * PI/2)
		for i in range(0, get_slide_count()):
			if get_slide_collision(i).collider.is_in_group("Enemy") or get_slide_collision(i).collider.is_in_group("Enemy_Bullet"):
				harm(get_slide_collision(i).collider.damage)
		if inv > 0:
			inv -= delta
			if inv < 0:
				inv = 0
		if 4 * inv > 3 * rebound:
			hide()
		elif 2 * inv > rebound:
			show()
		elif 4 * inv > rebound:
			hide()
		else:
			show()

func harm(hurt):
	if !inv:
		HP -= hurt
		inv = rebound
		if HP <= 0:
			get_tree().paused = true
			hide()