extends Node2D

#useful game vars
var dmg = 10

#visual vars
var explosion_name = "regular explosion"
var debris_texture = "res://assets/imgs/gear/guns/gun01.png"

#convenience vars
onready var _global = get_node("/root/global")

#signals
signal killed


func _ready():
	get_node("RigidBody2D/custom_nodes/HP").setup(200.0)
	pass

func kill():
	emit_signal("killed")
	
	var pos = get_node("RigidBody2D/CollisionPolygon2D/Sprite").get_global_pos()
	var explosion = _global.get_node("Pools")._get_pooled_node("Explosions","res://src/fx/Explosion.tscn")
	explosion.play(pos, explosion_name)
	
	var emitter = _global.get_node("Pools")._get_pooled_node("Debris","res://src/fx/Debris.tscn")
	emitter.set_texture(load(debris_texture))
	emitter.set_global_pos(pos)
	emitter.set_emitting(true)
	
	queue_free() #release back into the pool, or connect it to the signal maybe?
