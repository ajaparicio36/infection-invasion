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
		target_enemy_id = area.get_parent().enemy_id  # Assuming the Area2D is a child of the enemy
		emit_signal("hit", damage, target_enemy_id)
		queue_free()
