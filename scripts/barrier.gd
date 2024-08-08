extends Node2D

signal destroyed

var hp = 100

func _ready():
	print("Barrier " + str(get_instance_id()) + " initialized with " + str(hp) + " HP")
	add_to_group("barrier_area")

func take_damage(damage: int, enemy_id: int):
	print("Barrier.take_damage called on " + str(self) + " with damage: " + str(damage) + " from enemy: " + str(enemy_id))
	hp -= damage
	print("Barrier " + str(get_instance_id()) + " HP reduced to " + str(hp))
	if hp <= 0:
		print("Barrier " + str(get_instance_id()) + " destroyed!")
		queue_free()

func _on_area_2d_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("enemy"):
		print("Enemy %d entered barrier area" % parent.get_instance_id())
		parent.attack(self)
