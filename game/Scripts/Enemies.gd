extends Node2D

var active
var gated

func _ready():
	active = false
	gated = false
	
func _process(delta):
	if gated and get_child_count() == 2:
		gated = false
		$Gate.hide()
		$Gate/TileMap.set_collision_layer_bit(2, 0)
		$Gate/TileMap.set_collision_mask_bit(0, 0)

func _body_entered(body):
	if !active:
		if body.is_in_group("Player"):
			active = true
			gated = true
			$Gate.show()
			$Gate/TileMap.set_collision_layer_bit(2, 1)
			$Gate/TileMap.set_collision_mask_bit(0, 1)
		elif body.is_in_group("Player_Bullet"):
			body.queue_free()
		elif body.is_in_group("Enemy_Bullet"):
			body.queue_free()