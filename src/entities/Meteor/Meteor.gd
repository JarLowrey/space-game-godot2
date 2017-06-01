extends Node2D

onready var _global = get_node("/root/global")

func _ready():
	_init_body(null)
	pass

func _init_body(color):
	get_node("RigidBody2D/custom_nodes/HP").setup(20.0)
	get_node("RigidBody2D").set_linear_velocity(Vector2(rand_range(-100,100),rand_range(-100,100)))
	set_rot(rand_range(0, 2 * PI))
	
	if color:
		var tx = _get_texture_name().replace("Brown",color).replace("Grey",color)
		get_node("RigidBody2D/CollisionPolygon2D/Sprite").set_texture(load("res://assets/imgs/meteors/"+tx+".png"))
	else:
		_randomize_texture()

func change_size(size):
	var bodies_in_similar_sizes = _global.meteor_json[size]
	var body_scene_name = bodies_in_similar_sizes[randi() % bodies_in_similar_sizes.size()] + ".tscn"
	body_scene_name = body_scene_name.replace("Brown","").replace("Grey","")
	_global.change_body(self,"res://src/bodies/meteor/"+body_scene_name)
	
	var color = "Brown"
	if _get_texture_name().find("Grey") > -1:
		color = "Grey"
		
	_init_body(color)

func _randomize_texture():
	var tx = _get_texture_name()
	if _get_texture_name().find("Brown") > -1 and randf() < 0.5:
		tx = tx.replace("Brown","Grey")
		get_node("RigidBody2D/CollisionPolygon2D/Sprite").set_texture(load("res://assets/imgs/meteors/"+tx+".png"))

func _get_texture_name():
	return get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_texture().get_name().split(".")[0]

func get_size():	
	for size in _global.meteor_json:
		for texture_name in _global.meteor_json[size]:
			if _get_texture_name() == texture_name:
				return size
	
	return null #shouldn't ever happen

func _create_meteors(low,high,size):
	var num_meteors = randi()%(high-low) + low
	
	for i in range(0,num_meteors):
		var meteor = load("res://src/entities/Meteor/Meteor.tscn").instance()
		get_node("/root").add_child(meteor)
		meteor.set_global_pos(get_node("RigidBody2D").get_global_pos())
		meteor.change_size(size)

func _spawn_child_meteors():
	var my_size = get_size()
	if my_size == "xlarge":
		_create_meteors(0,1,"large")
		_create_meteors(0,3,"medium")
		_create_meteors(0,2,"small")
	elif my_size == "large":
		_create_meteors(1,3,"medium")
		_create_meteors(0,3,"small")
	elif my_size == "med":
		_create_meteors(0,2,"small")
#		_create_meteors(1,3,"tiny")
#	elif my_size == "small":
#		_create_meteors(0,2,"tiny")

func kill():	
	var emitter = get_node("/root/global/Pools")._get_pooled_node("Debris","res://src/fx/Debris.tscn")
	if _get_texture_name().find("Grey") > -1:
		emitter.set_texture(load("res://assets/imgs/meteors/meteorGrey_tiny2.png"))
	else:
		emitter.set_texture(load("res://assets/imgs/meteors/meteorBrown_tiny2.png"))
	emitter.set_global_pos(get_node("RigidBody2D").get_global_pos())
	emitter.set_emitting(true)
	
	_spawn_child_meteors()
	
	queue_free()