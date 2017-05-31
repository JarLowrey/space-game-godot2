extends Sprite

var can_use = true

func play(pos,anim_name):
	set_global_pos(pos)
	var anim = get_node("AnimationPlayer")
	anim.play(anim_name)
	can_use = false
	set_hidden(false)

func _can_use_again():
	set_hidden(true)
	can_use = true

func _ready():
	var anim = get_node("AnimationPlayer")
	anim.connect("finished",self,"_can_use_again")
	pass
