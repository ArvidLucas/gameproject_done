extends Node

export (int) var rooms
export (int) var powerups
export (int) var size
var CELL_SIZE = 2038
var queue_new_floor
var depth
var player_bullet
var enemy_bullet
var bullet
var map
var rseed

func _ready():
	player_bullet = load("res://Objects/PlayerBullet.tscn")
	enemy_bullet = load("res://Objects/EnemyBullet.tscn")
	queue_new_floor = false
	if ProjectSettings.get("load"):
		load_game()
		seed(rseed)
		new_floor()
	else:
		depth = 1
		new_seed()
		save_game()
		new_floor()

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene("res://Menu/Menu.tscn")
	if queue_new_floor:
		queue_new_floor = false
		map.queue_free()
		depth += 1
		rooms = depth * 10
		powerups = depth * 4
		$Player.position = Vector2(CELL_SIZE/2, CELL_SIZE/2)
		save_game()
		new_floor()

func new_seed():
	randomize()
	rseed = randi()
	seed(rseed)

func new_floor():
	map = load("res://Rooms/Size" + str(size) + "/Floor.tscn").instance()
	map.name = "Floor"
	add_child(map)

func get_difficulty():
	if depth <= 2:
		return 1
	if depth >= 3:
		return 2

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
	bullet.velocity = vect_to_player(pos).normalized()
	bullet.velocity *= bullet_speed
	bullet.damage = bullet_damage
	add_child(bullet)

func _enemy_orient(enemy, pos):
	var vector = vect_to_player(pos)
	if vector.y > 0:
		enemy.orientate(atan(-vector.x / vector.y) + PI)
	elif vector.y < 0:
		enemy.orientate(atan(-vector.x / vector.y))
	elif vector.x != 0:
		enemy.orientate(vector.x * PI/2)

func vect_to_player(pos):
	return ($Player.position - pos)

func _goal_entered(body):
	queue_new_floor = true

func _player_die():
	var save_data = {
		"depth" : 0
	}
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	get_tree().change_scene("res://Menu/Menu.tscn")

func save_game():
	var save_data = {
		"seed" : rseed,
		"depth" : depth,
		"HP" : $Player.HP,
		"speed" : $Player.speed,
		"bullet_damage" : $Player.bullet_damage,
		"bullet_speed" : $Player.bullet_speed,
		"fire_rate" : $Player.fire_rate,
		"rebound" : $Player.rebound
	}
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_game():
	var save_data
	var save_file = File.new()
	save_file.open("user://savegame.save", File.READ)
	save_data = parse_json(save_file.get_as_text())
	rseed = save_data["seed"]
	depth = save_data["depth"]
	rooms = rooms * depth
	powerups = powerups * depth
	$Player.HP = save_data["HP"]
	$Player.update_HP()
	$Player.speed = save_data["speed"]
	$Player.bullet_damage = save_data["bullet_damage"]
	$Player.bullet_speed = save_data["bullet_speed"]
	$Player.fire_rate = save_data["fire_rate"]
	$Player.rebound = save_data["rebound"]
	save_file.close()