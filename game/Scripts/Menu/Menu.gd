extends Node

var save_data
var new
var menu

func _ready():
	VisualServer.set_default_clear_color(Color(0))
	check_game()
	if new:
		menu = load("res://Menu/MainNew.tscn").instance()
	else:
		menu = load("res://Menu/MainOld.tscn").instance()
	add_child(menu)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func check_game():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		save_data = {
			"depth" : 0
		}
		save_file.open("user://savegame.save", File.WRITE)
		save_file.store_line(to_json(save_data))
	else:
		save_file.open("user://savegame.save", File.READ)
		save_data = parse_json(save_file.get_as_text())
	save_file.close()
	if save_data["depth"] == 0:
		new = true