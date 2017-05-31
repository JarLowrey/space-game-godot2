extends Particles2D

var can_use = true

func set_emitting(active):
	.set_emitting(active)
	can_use = active