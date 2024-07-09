extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var muzzle = $Muzzle
var Bullet = preload("res://scenes/projectile.tscn")

var fire_rate = 0.2
var can_fire = true
var fire_timer = 0.0

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("down"):
		velocity.y += SPEED
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("right"):
		velocity.x += SPEED
	velocity = velocity.normalized() * SPEED
	
	if Input.is_action_pressed("shoot") and can_fire:
		shoot();
		can_fire = false
		fire_timer = fire_rate
		if animated_sprite.animation != "shooting" or not animated_sprite.is_playing():
			animated_sprite.play("shooting")
	elif velocity != Vector2.ZERO:
		animated_sprite.play("walking")
	else:
		animated_sprite.play("idle")
	
	if not can_fire:
		fire_timer -= delta
		if fire_timer <= 0:
			can_fire = true
	
	look_at(get_global_mouse_position())
	rotate(PI/2)
	move_and_slide();
	
	

func shoot():
	var bullet = Bullet.instantiate()
	bullet.position = muzzle.global_position
	bullet.direction = Vector2.UP.rotated(rotation)
	bullet.scale = Vector2(0.1, 0.1)
	get_parent().add_child(bullet)
	animated_sprite.play("shooting")
