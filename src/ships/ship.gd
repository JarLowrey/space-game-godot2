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
	var pos = get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_global_pos()
	var explosion = get_node("/root/global/Pools")._get_pooled_node("Explosions","res://src/fx/Explosion.tscn")
	explosion.play(pos, "regular explosion")
	
	var emitter = get_node("/root/global/Pools")._get_pooled_node("Debris","res://src/fx/Debris.tscn")
	emitter.set_texture(load("res://assets/imgs/gear/guns/gun01.png"))
	emitter.set_global_pos(pos)
	emitter.set_emitting(true)

	print("kill")
