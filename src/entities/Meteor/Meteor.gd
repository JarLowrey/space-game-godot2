extends Node2D

onready var _global = get_node("/root/global")
var dmg = 5

func _ready():
	_init_body(null)
	pass

func _init_body(color):
	set_rot(rand_range(0, 2 * PI))
	
	get_node("RigidBody2D/custom_nodes/HP/HealthBar").set_pos(Vector2())#must reset hp bar position sometimes
	get_node("RigidBody2D/custom_nodes/HP").setup(_get_hp())
	
	get_node("RigidBody2D").set_linear_velocity(Vector2(rand_range(-100,100),rand_range(-100,100)))
	
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

func _get_hp():
	var size = get_size()
	if size == "tiny":
		return 20
	if size == "small":
		return 30
	if size == "medium":
		return 50
	if size == "large":
		return 70
	if size == "xlarge":
		return 100

func get_size():	
	for size in _global.meteor_json:
		if _global.meteor_json[size].has(_get_texture_name()):
			return size
	
	return null #shouldn't ever happen

func _create_meteors(low,high,size):
	var num_meteors = randi()%(high-low) + low

	for i in range(0,num_meteors):
		var meteor = load("res://src/entities/Meteor/Meteor.tscn").instance()
		get_node("/root").add_child(meteor)
		
#		position the new meteors so theyre not on top of one another	
		var pos = get_node("RigidBody2D").get_global_pos()
		var dimen = get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_item_rect().size
		pos.x += (randf()*4-2)* dimen.x/2
		pos.y += (randf()*4-2)* dimen.y/2
		meteor.set_global_pos(pos)
		
		meteor.change_size(size)

func _spawn_child_meteors():
	var my_size = get_size()
	if my_size == "xlarge":
		_create_meteors(0,1,"large")
		_create_meteors(0,3,"medium")
		_create_meteors(0,2,"small")
	elif my_size == "large":
		_create_meteors(1,2,"medium")
		_create_meteors(0,2,"small")
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