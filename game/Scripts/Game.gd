extends Node

const CELL_SIZE = 2304
var player_bullet
var enemy_bullet
var bullet
var room

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")
	enemy_bullet = load("res://Objects/EnemyBullet.tscn")
	set_room(Vector2(0, 0), 11)
	set_bridge(Vector2(1, 0), 0)
	set_room(Vector2(1, 0), 13)

func set_room(pos, n):
	pos *= CELL_SIZE
	room = load("res://Rooms/Room" + str(n) + ".tscn").instance()
	room.position = pos
	add_child(room)
	
func set_bridge(pos, n):
	pos *= CELL_SIZE
	pos.x -= CELL_SIZE / 3
	pos.y -= CELL_SIZE / 3
	room = load("res://Rooms/Bridge" + str(n) + ".tscn").instance()
	room.position = pos
	add_child(room)

func _player_shoot(bullet_speed, bullet_damage):
	bullet = player_bullet.instance()
	bullet.position = $Player.position
	bullet.velocity = ($Player/Camera2D.get_global_mouse_position() - $Player.position).normalized()
	bullet.velocity *= bullet_speed
	bullet.damage = bullet_damage
	add_child(bullet)


func _enemy_shoot(bullet_speed, bullet_damage, pos):
	bullet = enemy_bullet.instance()
	bullet.position = pos
	bullet.velocity = ($Player.position - pos).normalized()
	bullet.velocity *= bullet_speed
	bullet.damage = bullet_damage
	add_child(bullet)