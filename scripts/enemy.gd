extends Node2D

var hp = 100

signal get_damage()

func deal_damage(damage):
	hp -= damage

func _process(delta):
	if hp <= 0:
		queue_free()
