extends Node2D

var force_amt = 50
export var rot_speed_divider = 7

func _ready():
	set_process(true)
	var glob = get_node("/root/global")
	glob.change_body(get_node("ship"),"res://src/bodies/player_ship1.tscn","")
	add_guns()
	glob.set_mask(get_node("ship/RigidBody2D"),glob.FACTIONS.player)
	get_node("ship/RigidBody2D/custom_nodes/HP").setup(100,"regular explosion",load("res://assets/imgs/gear/guns/gun01.png"))
	pass
	
func add_guns():
	for pos in get_node("ship/RigidBody2D/CollisionPolygon2D/gun_locations").get_children():
		var gun = load("res://src/ship_systems/weapons/guns/basic_gun.tscn").instance()
#		gun.auto_fire = (false)
		pos.add_child(gun)

func _move():
	var force = Vector2()
	var pressed = false
	if Input.is_action_pressed("ui_up"):
		pressed = true
		force += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		pressed = true
		force += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		pressed = true
		force += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		pressed = true
		force += Vector2(1, 0)
	force *= force_amt
	
	if pressed:
		var body = get_node("ship/RigidBody2D")
		body.apply_impulse(Vector2(), force)
		# #cannot rotate the body, must use a PID system for bodies
		var rot_step = get_node("/root/global").get_rot_step(body.get_node("CollisionPolygon2D").get_global_rot(), force.angle() - PI/2, rot_speed_divider)
		body.get_node("CollisionPolygon2D").rotate(rot_step)

func _process(delta):
	_move()