extends Node

export (int) var rooms
export (int) var rooms_increase
export (int) var powerups
export (int) var powerups_increase
var size = 1
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
	if queue_new_floor:
		queue_new_floor = false
		map.queue_free()
		depth += 1
		rooms += rooms_increase
		powerups += powerups_increase
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
	move_child(map, 0)

func get_difficulty():
	if depth <= 3:
		return 1
	return 2

func _player_shoot(speed, damage):
	bullet = player_bullet.instance()
	bullet.damage = damage
	bullet.position = $Player.position
	bullet.velocity = ($Player/Cam.get_global_mouse_position() - $Player.position).normalized()
	bullet.velocity *= speed
	add_child(bullet)
	move_child(bullet, 1)

func _enemy_shoot(speed, dam, pos, count, spread):
	var angle = angle_to_player(pos)
	if count == 0:
		spawn_enemy_bullet(angle, speed, dam, pos)
	else:
		var i = 0
		while (i <= spread * 2):
			spawn_enemy_bullet(angle_to_player(pos) - spread + i, speed, dam, pos)
			i += spread * 2 / count

func spawn_enemy_bullet(angle, speed, damage, pos):
	bullet = enemy_bullet.instance()
	bullet.damage = damage
	bullet.position = pos
	bullet.velocity = Vector2(cos(angle), sin(angle))
	bullet.velocity *= speed
	add_child(bullet)
	move_child(bullet, 1)

func _enemy_orient(enemy, pos):
	enemy.orientate(angle_to_player(pos))

func vect_to_player(pos):
	return $Player.position - pos

func angle_to_player(pos):
	var vect = vect_to_player(pos)
	if vect.x > 0:
		return atan(vect.y / vect.x)
	if vect.x < 0:
		return atan(vect.y / vect.x) + PI
	if vect.y > 0:
		return Vector2(0, 1)
	return Vector2(0, -1)

func _goal_entered(body):
	queue_new_floor = true

func _player_die():
	var save_data = {
		"depth" : -1
	}
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	get_tree().change_scene("res://Menu/Menu.tscn")

func _play_death_sound():
	$Death.play()

func save_game():
	var save_data = {
		"seed" : rseed,
		"depth" : depth,
		"rooms" : rooms,
		"powerups" : powerups,
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
	rooms = save_data["rooms"]
	powerups = save_data["powerups"]
	$Player.HP = save_data["HP"]
	$Player.update_HP()
	$Player.speed = save_data["speed"]
	$Player.bullet_damage = save_data["bullet_damage"]
	$Player.bullet_speed = save_data["bullet_speed"]
	$Player.fire_rate = save_data["fire_rate"]
	$Player.rebound = save_data["rebound"]
	save_file.close()