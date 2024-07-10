extends Node2D  # or whatever your main scene extends

@onready var player = $Player
@onready var hud = $HUD

func _ready():
	player.connect("update_hud", Callable(hud, "update_hud"))
