extends Node

const CELL_SIZE = 3072
var string = ""
var room

func _ready():
	gen_map()

func gen_map():
	var rooms = self.get_parent().rooms
	var powerups = self.get_parent().powerups
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
	for i in range(0, powerups):
		set_powerup(map[randi() % (rooms - 1)], randi() % 3)
	for i in range(1, rooms - 1):
		set_enemies(map[i], randi() % 1)
	set_goal(map[rooms - 1], 0)

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

func get_powerup(n):
	match n:
		0:
			string = "Damage"
		1:
			string = "Health"
		2:
			string = "Speed"

func set_room(pos, s):
	s_to_str(s)
	room = load("res://Rooms/Room" + string + ".tscn").instance()
	room.position = pos * CELL_SIZE
	add_child(room)

func set_enemies(pos, n):
	room = load("res://Enemies/Enemies" + str(n) + ".tscn").instance()
	room.position = pos * CELL_SIZE
	room.position.x += CELL_SIZE / 4
	room.position.y += CELL_SIZE / 4
	add_child(room)

func set_goal(pos, n):
	room = load("res://Rooms/Goal" + str(n) + ".tscn").instance()
	room.position = pos * CELL_SIZE
	add_child(room)

func set_powerup(pos, n):
	get_powerup(n)
	room = load("res://Objects/Power" + string + ".tscn").instance()
	room.position = pos * CELL_SIZE
	room.position.x += CELL_SIZE / 2
	room.position.y += CELL_SIZE / 2
	room.position += Vector2(randi() % 1300 - 700, randi() % 1300 - 700)
	add_child(room)