extends Node2D

var hp = 100

func deal_damage(damage):
	hp -= damage
	print(hp)

func _process(delta):
	if hp <= 0:
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		deal_damage(20)
		print("hit enemy")
