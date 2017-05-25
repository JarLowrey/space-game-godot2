extends Node

#singleton in godot:
#http://docs.godotengine.org/en/2.1/learning/step_by_step/singletons_autoload.html

enum FACTIONS{
	player = 0,
	enemy = 1
}

func set_mask(node,faction):
	for team in FACTIONS:
		var team_faction = FACTIONS[team]
		var my_faction = team_faction == faction
		node.set_layer_mask_bit(team_faction,my_faction)
		node.set_collision_mask_bit(team_faction,!my_faction)

func resize_to(ref_rec, resizable):
    var size = ref_rec.size
    var pos = -size/2
    resizable.edit_set_rect(Rect2(pos,size))

func check_angle_discontinuity(angle):
	if(angle > PI):  
	   angle = angle - PI * 2
	elif(angle < -PI):
	   angle = angle + PI * 2
	return angle

func get_rot_step(curr_rot, dest_angle,rot_speed_divider):	
	#ensure always turn the quickest direction
	var error = dest_angle - curr_rot
	error = check_angle_discontinuity(error)
	
	var step  = error / rot_speed_divider
	return step

func change_body(node,body_path,script_path):
	var new_body = load(body_path).instance()
	new_body.set_name("RigidBody2D")
	if script_path and script_path.length() > 0:
		new_body.set_script(load(script_path))
	
	if node.has_node("RigidBody2D"):
		var old_body = node.get_node("RigidBody2D")
		old_body.set_name("delete_me_thx_Aaaaaaaaa")
		for child in old_body.get_node("import_nodes").get_children():
			old_body.get_node("import_nodes").remove_child(child)
			new_body.get_node("import_nodes").add_child(child)
		old_body.free()
	
	node.add_child(new_body)