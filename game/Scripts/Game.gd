extends Node

export (int) var rooms
const CELL_SIZE = 3072
var string = ""
var player_bullet
var enemy_bullet
var bullet
var room

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")
	enemy_bullet = load("res://Objects/EnemyBullet.tscn")
	randomize()
	gen_map()

func gen_map():
	var d
	var prev
	var pos = Vector2(0, 0)
	var map = [pos]
	var s = [1]
	for i in range(1, rooms):
		while (is_in_map(pos, map)):
			d = randi() % 4
			pos += d_to_pos(d)
		prev = find_in_map(pos+d_to_pos(invert(d)), map)
		s[prev] *= d_to_prime(d)
		map.append(pos)
		s.append(1)
		s[i] *= d_to_prime(invert(d))
	for i in range(0, rooms):
		set_room(map[i], s[i])

func d_to_pos(d):
	var pos = Vector2(0, 0)
	match d:
		0:
			pos += Vector2(0, -1)
		1:
			pos += Vector2(1, 0)
		2:
			pos += Vector2(0, 1)
		3:
			pos += Vector2(-1, 0)
	return pos

func is_in_map(pos, map):
	for m in map:
		if pos == m:
			return true
	return false

func find_in_map(pos, map):
	var i = 0
	for m in map:
		if pos == m:
			return i
		i += 1

func invert(d):
	return (d + 2) % 4

func d_to_prime(d):
	match d:
		0:
			return 2
		1:
			return 3
		2:
			return 5
		3:
			return 7

func s_to_str(s):
	string = ""
	if (s % 2 == 0):
		string = string + "0"
	if (s % 3 == 0):
		string = string + "1"
	if (s % 5 == 0):
		string = string + "2"
	if (s % 7 == 0):
		string = string + "3"

func set_room(pos, s):
	s_to_str(s)
	room = load("res://Rooms/Room" + string + ".tscn").instance()
	room.position = pos * CELL_SIZE
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