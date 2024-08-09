extends Node2D

var hp = 100
var max_hp = 100
var barrier_id: int
var is_destroyed = false
@onready var collision = $StaticBody2D/CollisionShape2D

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
	collision.set_deferred("disabled", true)
	# Change appearance to show it's destroyed
	modulate = Color(0.5, 0.5, 0.5, 0.5)  # Example: make it semi-transparent
	# Notify zombies that the barrier is destroyed
	get_tree().call_group("enemy", "on_barrier_destroyed", self)

func _on_area_2d_area_entered(area):
	if not is_destroyed:
		var parent = area.get_parent()
		if parent is zombie or parent is zombie_brute or parent is zombie_sprinter:
			parent.attack_barrier(self)
