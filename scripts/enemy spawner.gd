extends Area2D

var Enemy = preload("res://scenes/enemy.tscn")  # Adjust the path to your enemy scene
@export var spawn_radius: float = 100.0  # Radius around the entered area to spawn the enemy

func _on_area_entered(area):
	print("Area entered")
	if area.is_in_group("player"):  # Assuming you want to spawn when the player enters
		spawn_enemy_near(area.global_position)

func spawn_enemy_near(center_position: Vector2):
	var new_enemy = Enemy.instantiate()
	new_enemy.scale = Vector2(0.2, 0.2)
	# Generate a random position within the spawn radius
	var random_angle = randf() * 2 * PI
	var random_distance = randf() * spawn_radius
	var spawn_position = center_position + Vector2(cos(random_angle), sin(random_angle)) * random_distance
	
	new_enemy.position = spawn_position
	
	# Add the enemy to the scene
	get_tree().current_scene.add_child(new_enemy)
	
	# Connect necessary signals
	var weapon = get_node_or_null("/root/World/Player/Weapon")
	if weapon:
		weapon.connect("bullet_hit", Callable(new_enemy, "deal_damage"))
	
	# Connect the get_damage signal for debugging
	new_enemy.connect("get_damage", Callable(self, "_on_enemy_damage"))
	
	print("Spawned enemy " + str(new_enemy.enemy_id) + " at position: ", spawn_position)


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Area shape entered")

func _on_enemy_damage(enemy_id: int, current_hp: int):
	print("Enemy " + str(enemy_id) + " damaged. Current HP: " + str(current_hp))
