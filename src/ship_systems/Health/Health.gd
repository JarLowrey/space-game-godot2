extends Node2D

enum EXPLOSIONS{
	regular,
	sonic,
	none
}
const bar_height = 20
const bar_margin = 30
var health = 0
var _exp_anim_name = ""
var _ship = null

func setup(hp, explosion_name, damage_tx):
	health = hp
	get_node("DamageEffect").set_texture(damage_tx)
	_exp_anim_name = explosion_name
	_resize_bar()

func _ready():
	_ship = get_node("../..")
	set_process(true)

func _process(delta):
	set_global_rot(0) #inefficient...better way of doing this???

func damage(amt,pos):
	health -= amt
	get_node("DamageEffect").set_emitting(true)
	
	if health <= 0:
		get_node("Explosion/AnimationPlayer").play(_exp_anim_name)
		_ship.kill()

func _resize_bar():
	var bar = get_node("HealthBar")
	var sprite = _ship.get_node("CollisionPolygon2D/Sprite")
	var parent_size = sprite.get_item_rect().size
	#x and y are reversed on the bodies, so reverse them here too
	var pos = Vector2(-parent_size.y/2, -parent_size.x/2 - bar_height - bar_margin)
	var size = Vector2(parent_size.y, bar_height)
	bar.edit_set_rect(Rect2(pos,size))