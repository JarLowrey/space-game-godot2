extends Node2D

enum EXPLOSIONS{
	regular,
	sonic,
	none
}

var health = 0
var _exp_anim_name = ""

func setup(hp, explosion_name, damage_tx):
	health = hp
	get_node("DamageEffect").set_texture(damage_tx)
	_exp_anim_name = explosion_name
	_resize_bar()

func damage(amt,pos):
	health -= amt
	get_node("DamageEffect").set_emitting(true)
	
	if health <= 0:
		get_node("Explosion/AnimationPlayer").play(_exp_anim_name)
		get_parent().kill()

func _resize_bar():
	var bar = get_node("../HealthBar")
	var parent_size = get_parent().get_item_rect().size
	var pos = Vector2(0, -parent_size.y/2)
	var size = Vector2(parent_size.x, 20)
	bar.edit_set_rect(Rect2(pos,size))