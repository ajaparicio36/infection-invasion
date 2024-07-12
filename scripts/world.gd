extends Node2D  # or whatever your main scene extends

@onready var weapon = $Player/Weapon
@onready var hud = $HUD

func _ready():
	weapon.connect("take_damage", Callable(hud, "take_damage"))
	weapon.connect("set_weapon", Callable(hud, "set_weapon"))
	weapon.connect("set_ammo", Callable(hud, "set_ammo"))
