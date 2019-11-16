extends Node

var player_bullet

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")

func _player_shoot(bullet_speed):
	var bullet = player_bullet.instance()
	add_child(bullet)
	bullet.position = $Player.position
	bullet.velocity = ($Player/Camera2D.get_global_mouse_position() - $Player.position).normalized()
	bullet.velocity *= bullet_speed