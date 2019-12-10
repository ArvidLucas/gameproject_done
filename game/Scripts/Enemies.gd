extends Node2D

var active
var gated
var gate

func _ready():
	active = false
	gated = false
	var size = get_parent().size
	gate = load("res://Rooms/Size" + str(size) + "/Gate.tscn").instance()

func _process(delta):
	if gated and get_child_count() == 2:
		gated = false
		gate.queue_free()

func _body_entered(body):
	if !active:
		if body.is_in_group("Player"):
			active = true
			gated = true
			add_child(gate)
		elif body.is_in_group("Player_Bullet"):
			body.queue_free()
		elif body.is_in_group("Enemy_Bullet"):
			body.queue_free()