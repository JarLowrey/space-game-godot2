extends Node

var cam = null

func _ready():
	var player = get_node("/root/Node/player")
	cam = player.get_node("ship/RigidBody2D/custom_nodes/Camera2D")
	get_node("Meteors").connect("timeout",self,"spawn_meteor")
	pass

func spawn_meteor():
	#do not spawn if player is dead/freed
	if !cam:
		return
	
	var meteor = get_node("/root/global/Pools")._get_pooled_node("Meteors","res://src/entities/Meteor/Meteor.tscn")
	
#	var meteor = load("res://src/entities/Meteor/Meteor.tscn").instance()
#	get_node("/root").add_child(meteor)
	
	var ang_pos = randf() * 2 * PI
	var size = get_viewport().get_visible_rect().size * .75
	var x = size.x * cos(ang_pos)
	var y = size.y * sin(ang_pos)
	meteor.set_global_pos(cam.get_global_pos() + Vector2(x,y))
	
	meteor.change_size("large")