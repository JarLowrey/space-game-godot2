extends Node

#singleton in godot:
#http://docs.godotengine.org/en/2.1/learning/step_by_step/singletons_autoload.html

enum FACTIONS{
	player = 0,
	enemy = 1
}
var meteor_json = {}

func _ready():	
	var file = File.new()
	file.open("res://assets/json/meteor_sizes.json",File.READ)
	meteor_json.parse_json(file.get_as_text())
	randomize()

func life_change(entity,alive):
	entity.set_process(alive)
	entity.set_fixed_process(alive)
	entity.set_hidden(!alive)
	entity.set("can_use",!alive)

func derive_mass(node):
	var dimen = node.get_item_rect().size
	var area = dimen.x * dimen.y
	#standardize 100x100 to have a mass of 100
	return sqrt(area)

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

func change_body(node,body_path):
	var new_body = load(body_path).instance()
	new_body.set_name("RigidBody2D")
	new_body.set_mass(derive_mass(new_body))
	
	if node.has_node("RigidBody2D"):
		var old_body = node.get_node("RigidBody2D")
		old_body.set_name("delete_me_thx_Aaaaaaaaa")
		if old_body.has_node("custom_nodes"):
			for child in old_body.get_node("custom_nodes").get_children():
				old_body.get_node("custom_nodes").remove_child(child)
				new_body.get_node("custom_nodes").add_child(child)
		old_body.queue_free()
	
	node.add_child(new_body)