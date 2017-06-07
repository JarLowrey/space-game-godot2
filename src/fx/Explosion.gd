extends Sprite

var can_use = true

func play(pos,anim_name):
	get_node("/root/global").life_change(self,true)
	set_global_pos(pos)
	var anim = get_node("AnimationPlayer")
	anim.play(anim_name)

func _ready():
	var anim = get_node("AnimationPlayer")
	anim.connect("finished",get_node("/root/global"),"life_change",[self,false])
	pass
