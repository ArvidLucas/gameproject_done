extends KinematicBody2D

signal player_shoot

export (int) var speed
export (int) var drag
export (int) var bullet_speed
var input = Vector2()
var velocity = Vector2()

func _ready():
	connect("player_shoot", get_tree().get_root().get_node("Game"), "_player_shoot")

#warning-ignore:unused_argument
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
	if Input.is_action_just_pressed("player_shoot"):
		emit_signal("player_shoot", bullet_speed)
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func _physics_process(delta):
	velocity += input
	velocity /= drag
	move_and_slide(velocity * delta)