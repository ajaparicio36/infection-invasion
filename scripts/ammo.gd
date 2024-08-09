extends Node2D

class_name ammo

signal picked_up

func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("picked_up")
		queue_free()
