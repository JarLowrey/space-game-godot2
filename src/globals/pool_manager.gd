extends Node

func _get_pooled_node(pool_name,scene_name):
	for child in get_node(pool_name).get_children():
		if child.can_use:
			return child
	
	var node = load(scene_name).instance()
	get_node(pool_name).add_child(node)