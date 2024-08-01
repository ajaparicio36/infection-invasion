extends Area2D

var speed = 750
var direction = Vector2.ZERO
var damage = 0
var target_enemy_id = 0  # New variable to store the hit enemy's ID

signal hit(damage: int, enemy_id: int)

func _ready():
	add_to_group("bullet")

func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		var enemy = area.get_parent()
		if enemy.has_method("get_instance_id"):
			target_enemy_id = enemy.get_instance_id()
		emit_signal("hit", damage, target_enemy_id)
		queue_free()
	if area.is_in_group("walls"):
		print("map")
		queue_free()
