extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var barrel = $Barrel
var Bullet = preload("res://scenes/projectile.tscn")
var fire_rate = 0.1
var can_fire = true
var fire_timer = 0.0

signal take_damage(lost_hp)
signal set_weapon(new_weapon)

func signal_change_weapon(new_weapon):
	emit_signal("set_weapon", new_weapon)

func signal_take_damage(lost_hp):
	emit_signal("take_damage", lost_hp)

func _ready():
	emit_signal("set_weapon", "rifle")

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = barrel.global_position
	bullet.direction = Vector2.UP.rotated(barrel.global_rotation)
	bullet.scale = Vector2(0.07, 0.07)
	get_parent().get_parent().add_child(bullet)
	signal_take_damage(5)

func _process(delta):
	if Input.is_action_pressed("shoot") and can_fire:
		shoot();
		can_fire = false
		fire_timer = fire_rate
	
	if not can_fire:
		fire_timer -= delta
		if fire_timer <= 0:
			can_fire = true
