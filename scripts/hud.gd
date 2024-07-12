extends Control

@onready var hp_label = $HPLabel
@onready var weapon_label = $WeaponLabel
@onready var ammo_label = $AmmoLabel
@onready var camera = get_viewport().get_camera_2d()

var hp = 100
var weapon = "Pistol"
var ammo = 10000000

func _ready():
	update_hud(hp, weapon, ammo)

func update_hud(hp, weapon, ammo):
	if ammo >= 1000000:
		ammo_label.text = "Ammo: Infinite"
	else:
		ammo_label.text = "Ammo: " + str(ammo)
	hp_label.text = "HP: " + str(hp)
	weapon_label.text = "Weapon: " + weapon

func take_damage(lost_hp):
	hp -= lost_hp
	update_hud(hp, weapon, ammo)

func set_weapon(new_weapon):
	weapon = new_weapon
	update_hud(hp, weapon, ammo)

func set_ammo(new_ammo):
	ammo = new_ammo
	update_hud(hp, weapon, new_ammo)

func _process(delta):
	if camera:
		global_position = camera.get_screen_center_position() - get_viewport_rect().size / 2
