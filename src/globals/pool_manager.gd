extends Node

func _get_pooled_node(pool_name,scene_name):
	for child in get_node(pool_name).get_children():
		if child.get("can_use"):
			return child
	
	var node = load(scene_name).instance()
	get_node("/root/global").life_change(node,true)
	get_node("/root/global/Pools/"+pool_name).add_child(node)
	return node