extends Control

@onready var hp_label = $HPLabel
@onready var weapon_label = $WeaponLabel
@onready var camera = get_viewport().get_camera_2d()

func update_hud(hp, weapon):
	hp_label.text = "HP: " + str(hp)
	weapon_label.text = "Weapon: " + weapon

func _process(delta):
	if camera:
		global_position = camera.get_screen_center_position() - get_viewport_rect().size / 2
