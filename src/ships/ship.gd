extends Node2D

var dmg = 10

var _hp = null

func collision(body):
	_hp.damage(body,get_global_pos())
	return

func _ready():
	get_node("RigidBody2D").connect("body_enter",self,"collision")
	_hp = get_node("RigidBody2D/custom_nodes/HP")
	_hp.setup(20)
	pass

func kill():
	queue_free()
#	var size = get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_item_rect().size
	var explosion = load("res://src/fx/Explosion.tscn").instance()
	get_node("/root").add_child(explosion)
	explosion.play(get_global_pos(), "regular explosion")
	
	var emitter = load("res://src/fx/Debris.tscn").instance()
	get_node("/root").add_child(emitter)
	emitter.set_texture(load("res://assets/imgs/gear/guns/gun01.png"))
	emitter.set_global_pos(get_global_pos())
	emitter.set_emitting(true)

	print("kill")
