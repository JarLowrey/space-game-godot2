extends Node2D

var dmg = 10

func _ready():
	get_node("RigidBody2D/custom_nodes/HP").setup(200.0)
	pass

func kill():
	var pos = get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_global_pos()
	var explosion = get_node("/root/global/Pools")._get_pooled_node("Explosions","res://src/fx/Explosion.tscn")
	explosion.play(pos, "regular explosion")
	
	var emitter = get_node("/root/global/Pools")._get_pooled_node("Debris","res://src/fx/Debris.tscn")
	emitter.set_texture(load("res://assets/imgs/gear/guns/gun01.png"))
	emitter.set_global_pos(pos)
	emitter.set_emitting(true)
	
	queue_free()
