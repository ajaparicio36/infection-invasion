extends Area2D

var speed = 750
var direction = Vector2.ZERO

func _physics_process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
