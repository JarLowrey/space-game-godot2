extends RigidBody2D

onready var _global = get_node("/root/global")

func _ready():
	init_body(self)
	pass

func init_body(body):	
	body.set_contact_monitor(true)
	body.set_max_contacts_reported(1)
	body.set_mass(_global.derive_mass(body))
	