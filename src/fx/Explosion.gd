extends Sprite

func play(pos,anim_name):
	set_global_pos(pos)
	var anim = get_node("AnimationPlayer")
	anim.play(anim_name)
	
func _ready():
	var anim = get_node("AnimationPlayer")
	anim.connect("finished",self,"queue_free")
	pass
