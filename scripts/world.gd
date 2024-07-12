extends Node2D  # or whatever your main scene extends

@onready var player = $Player/Weapon
@onready var hud = $HUD

func _ready():
	player.connect("take_damage", Callable(hud, "take_damage"))
	player.connect("set_weapon", Callable(hud, "set_weapon"))
	player.connect("set_ammo", Callable(hud, "set_ammo"))
