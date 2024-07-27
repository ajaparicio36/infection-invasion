extends Node2D

@onready var canvas_modulate = $CanvasModulate
@onready var player_light = $Player/PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready():
	canvas_modulate.time_tick.connect(player_light.set_daytime)
