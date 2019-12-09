extends Node

export (int) var rooms
export (int) var powerups
export (int) var size
var queue_new_floor
var player_bullet
var enemy_bullet
var bullet
var map

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")
	enemy_bullet = load("res://Objects/EnemyBullet.tscn")
	queue_new_floor = false
	new_floor()

func _process(delta):
	if queue_new_floor:
		queue_new_floor = false
		map.queue_free()
		rooms += 10
		powerups += 3
		$Player.position = Vector2(1536, 1536)
		new_floor()

func new_floor():
	randomize()
	map = load("res://Rooms/Size" + str(size) + "/Floor.tscn").instance()
	map.name = "Floor"
	add_child(map)

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
	bullet.velocity = vect_to_player(pos)
	bullet.velocity *= bullet_speed
	bullet.damage = bullet_damage
	add_child(bullet)

func _enemy_orient(enemy, pos):
	var vector = vect_to_player(pos)
	if vector.y > 0:
		enemy.set_rotation(atan(-vector.x / vector.y) + PI)
	elif vector.y < 0:
		enemy.set_rotation(atan(-vector.x / vector.y))
	elif vector.x != 0:
		enemy.set_rotation(vector.x * PI/2)

func vect_to_player(pos):
	return ($Player.position - pos).normalized()

func _goal_entered(body):
	queue_new_floor = true