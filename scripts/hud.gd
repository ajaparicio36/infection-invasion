extends Control

@onready var hp_label = $HPLabel
@onready var weapon_label = $WeaponLabel
@onready var camera = get_viewport().get_camera_2d()

var hp = 100
var weapon = "Pistol"

func _ready():
	update_hud(hp, weapon)

func update_hud(hp, weapon):
	hp_label.text = "HP: " + str(hp)
	weapon_label.text = "Weapon: " + weapon

func take_damage(lost_hp):
	hp -= lost_hp
	update_hud(hp, weapon)

func set_weapon(new_weapon):
	update_hud(hp, new_weapon)

func _process(delta):
	if camera:
		global_position = camera.get_screen_center_position() - get_viewport_rect().size / 2
