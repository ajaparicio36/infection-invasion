extends PointLight2D

@export var night_hour = 17
@export var day_hour = 5
@export var point_light : PointLight2D

func set_daytime(_day: int, hour: int, minute: int) -> void:
	if hour <= day_hour or hour >= night_hour:
		point_light.enabled = true
	else:
		point_light.enabled = false
