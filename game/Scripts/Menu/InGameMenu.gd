extends Panel

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if !get_tree().paused:
			var camera = get_tree().get_root().get_node("Game/Player/Cam").get_camera_screen_center()
			rect_position.x = camera.x - 600
			rect_position.y = camera.y - 180
			show()
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false