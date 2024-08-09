extends Node2D

var hp = 100
var max_hp = 100
var barrier_id: int
var is_destroyed = false

@onready var collision_shape = $StaticBody2D/CollisionShape2D
 # Assuming you have a Sprite2D node for the barrier's appearance

func _ready():
	barrier_id = get_instance_id()
	add_to_group("barrier")

func take_damage(damage: int, enemy_id: int):
	if not is_destroyed:
		hp -= damage
		print("Barrier " + str(barrier_id) + " took " + str(damage) + " damage. HP: " + str(hp))
		
		if hp <= 0:
			destroy_barrier()

func destroy_barrier():
	is_destroyed = true
	collision_shape.set_deferred("disabled", true)
	modulate = Color(0.5, 0.5, 0.5, 0.5)  # Make it semi-transparent
	get_tree().call_group("enemy", "on_barrier_destroyed", self)

func repair():
	if is_destroyed:
		is_destroyed = false
		hp = max_hp
		collision_shape.set_deferred("disabled", false)
		modulate = Color(1, 1, 1, 1)  # Reset to full opacity
		print("Barrier " + str(barrier_id) + " repaired. HP: " + str(hp))

func _on_area_2d_area_entered(area):
	if not is_destroyed:
		var parent = area.get_parent()
		if parent is zombie or parent is zombie_brute or parent is zombie_sprinter:
			parent.attack_barrier(self)
