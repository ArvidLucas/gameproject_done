extends Node

var menu
var save_data
var new = false
var over = false

func _ready():
	VisualServer.set_default_clear_color(Color(0))
	check_save()
	if new:
		menu = load("res://Menu/MainNew.tscn").instance()
	elif over:
		menu = load("res://Menu/MainOver.tscn").instance()
	else:
		menu = load("res://Menu/MainOld.tscn").instance()
	add_child(menu)

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func check_save():
	var save_file = File.new()
	if not save_file.file_exists("user://savegame.save"):
		new_save(save_file)
	else:
		save_file.open("user://savegame.save", File.READ)
		save_data = parse_json(save_file.get_as_text())
		save_file.close()
	if save_data["depth"] == 0:
		new = true
	elif save_data["depth"] == -1:
		over = true
		new_save(save_file)

func new_save(save_file):
	save_data = {
		"depth" : 0
	}
	save_file.open("user://savegame.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()