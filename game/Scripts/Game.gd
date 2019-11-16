extends Node

var player_bullet
var enemy_bullet

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")

func _player_shoot(bullet_speed, bullet_damage):
	var bullet = player_bullet.instance()
	bullet.position = $Player.position
	bullet.velocity = ($Player/Camera2D.get_global_mouse_position() - $Player.position).normalized()
	bullet.velocity *= bullet_speed
	bullet.damage = bullet_damage
	add_child(bullet)

func _enemy_shoot(bullet_speed, bullet_damage, pos):
	
	pass