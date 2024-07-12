extends Area2D

var speed = 750
var direction = Vector2.ZERO

signal hit()

func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		emit_signal("hit")
		queue_free()
