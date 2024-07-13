extends Camera2D

var smoothing_speed = 10.0

func _process(delta):
	global_position = global_position.lerp(get_parent().global_position, smoothing_speed * delta)
