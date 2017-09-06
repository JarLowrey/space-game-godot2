extends Node2D

var health = 0.0 setget set_health
var max_health = 1.0 setget set_max_health

const bar_height = 20
const bar_margin = 30

var _my_entity = null
var _my_bar = null

func setup(hp):
	set_health(hp)
	set_max_health(hp)
	_resize_my_bar()

func _ready():
	_my_entity = get_node("..")
	_my_bar = get_node("HealthBar")
	_my_entity.get_node("RigidBody2D").connect("body_enter",self,"collision")
	_my_entity.get_node("RigidBody2D").connect("body_enter_shape",self,"collision_shape")
	_my_bar.set_hidden(true)
	set_fixed_process(true)

func collision_shape(body_id, body, body_shape, local_shape):
	collision(body)

func collision(body):
	damage(body,get_global_pos())
	
	var coll_entity = body.get_parent()
	if coll_entity.has_node("HP"):
		coll_entity.get_node("HP").damage(_my_entity,get_global_pos())
	return

func set_max_health(val):
	max_health = val
	if max_health < health:
		health = max_health
	if _my_bar:
		_my_bar.set_max(max_health)
		_my_bar.set_val(health)

func set_health(val):
	health = val
	if health > max_health:
		max_health = health
	if _my_bar:
		_my_bar.set_max(max_health)
		_my_bar.set_val(health)
		if health != max_health:
			_my_bar.set_hidden(false)
	
	if health <= 0:
		_my_entity.kill()

func _fixed_process(delta):
	set_global_pos(_my_entity.get_node("RigidBody2D").get_global_pos())

func damage(node,pos):
	var dmg = 0
	if node.get("dmg") != null:
		dmg = node.dmg
	else:
		dmg = node.get_parent().dmg
	
	set_health(health - dmg)
	
func _resize_my_bar():
	var sprite = _my_entity.get_node("RigidBody2D/CollisionPolygon2D/Sprite")
	var parent_size = sprite.get_item_rect().size
	#x and y are reversed on the bodies, so reverse them here too
	var size = Vector2(max(parent_size.y,50), bar_height)
	var pos = Vector2(-size.x/2, -parent_size.x/2 - bar_height - bar_margin)
	_my_bar.edit_set_rect(Rect2(pos,size))