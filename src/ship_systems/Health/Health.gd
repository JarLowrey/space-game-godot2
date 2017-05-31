extends Node2D

enum EXPLOSIONS{
	regular,
	sonic,
	none
}
var health setget set_health
var max_health setget set_max_health


const bar_height = 20
const bar_margin = 30

var _ship = null
var _bar = null

func setup(hp):
	health = hp
	max_health = hp
	_resize_bar()

func _ready():
	_ship = get_node("../../..")
	set_process(true)

func set_max_health(val):
	max_health = val
	if max_health < health:
		health = max_health
	if _bar:
		_bar.set_val(health / max_health)
	
func set_health(val):
	health = val
	if health > max_health:
		max_health = health
	if _bar:
		_bar.set_val(health / max_health)
	
	if health <= 0:
		_ship.kill()

func _process(delta):
	set_global_rot(0) #inefficient...better way of doing this???

func damage(node,pos):
	var dmg = 0
	if node.get("dmg"):
		dmg = node.dmg
	else:
		dmg = node.get_parent().dmg
	
	set_health(health - dmg)
	
func _resize_bar():
	_bar = get_node("HealthBar")
	var sprite = _ship.get_node("RigidBody2D/CollisionPolygon2D/Sprite")
	var parent_size = sprite.get_item_rect().size
	#x and y are reversed on the bodies, so reverse them here too
	var pos = Vector2(-parent_size.y/2, -parent_size.x/2 - bar_height - bar_margin)
	var size = Vector2(parent_size.y, bar_height)
	_bar.edit_set_rect(Rect2(pos,size))