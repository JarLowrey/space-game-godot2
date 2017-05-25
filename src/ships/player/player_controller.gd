extends Node2D

var force_amt = 50
export var rot_speed_divider = 7

func _ready():
	set_process(true)
	_init_body(get_node("RigidBody2D"))
	_change_body("res://src/bodies/player_ship1.tscn","")
	pass

func _change_body(body_path,script_path):
	var old_body = get_node("RigidBody2D")
	old_body.set_name("delete_me_thx_Aaaaaaaaa")
	var new_body = load(body_path).instance()
	new_body.set_name("RigidBody2D")
	_init_body(new_body)
	
	for child in old_body.get_node("import_nodes").get_children():
		old_body.get_node("import_nodes").remove_child(child)
		new_body.get_node("import_nodes").add_child(child)
	
	add_child(new_body)
	if script_path and script_path.length() > 0:
		new_body.set_script(load(script_path))
	old_body.free()

func _init_body(body):
	body.set_gravity_scale(0)
	body.set_linear_damp(5)
	body.set_angular_damp(1)

func _move():
	var force = Vector2()
	var pressed = false
	if Input.is_action_pressed("ui_up"):
		pressed = true
		force += Vector2(0, -force_amt)
	if Input.is_action_pressed("ui_down"):
		pressed = true
		force += Vector2(0, force_amt)
	if Input.is_action_pressed("ui_left"):
		pressed = true
		force += Vector2(-force_amt, 0)
	if Input.is_action_pressed("ui_right"):
		pressed = true
		force += Vector2(force_amt, 0)
	
#	var force = Vector2(cos(get_global_rot()), sin(get_global_rot())) * force_amt
	
	if pressed:
		var body = get_node("RigidBody2D")
		body.apply_impulse(Vector2(), force)
		get_node("/root/global")._set_rotation(body.get_node("Sprite"), force.angle(), rot_speed_divider)
		get_node("/root/global")._set_rotation(body.get_node("CollisionPolygon2D"), force.angle(), rot_speed_divider)

func _process(delta):
	_move()