extends Control

@onready var hp_label = $CanvasLayer/HPLabel
@onready var weapon_label = $CanvasLayer/WeaponLabel
@onready var ammo_label = $CanvasLayer/AmmoLabel
@onready var score_label = $CanvasLayer/ScoreLabel
@onready var camera = get_viewport().get_camera_2d()

var hp = 100
var weapon = "Pistol"
var ammo = 10000000
var score = 0

func _ready():
	update_hud(hp, weapon, ammo, score)

func update_hud(hp, weapon, ammo, score):
	if ammo >= 1000000:
		ammo_label.text = "Ammo: Infinite"
	else:
		ammo_label.text = "Ammo: " + str(ammo)
	hp_label.text = "HP: " + str(hp)
	weapon_label.text = "Weapon: " + str(weapon)
	score_label.text = "Score: " + str(score)

func set_hp(lost_hp):
	hp -= lost_hp
	update_hud(hp, weapon, ammo, score)

func set_weapon(new_weapon):
	weapon = new_weapon
	update_hud(hp, weapon, ammo, score)

func set_ammo(new_ammo):
	ammo = new_ammo
	update_hud(hp, weapon, new_ammo, score)
	
func add_score(amount):
	score += amount
	update_hud(hp, weapon, ammo, score)

func _process(delta):
	if camera and Globals.playerAlive:
		global_position = camera.get_screen_center_position() - get_viewport_rect().size / 2
