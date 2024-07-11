extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite = $AnimatedSprite2D

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
	
	if Input.is_action_pressed("shoot"):
		if animated_sprite.animation != "shooting" or not animated_sprite.is_playing():
			animated_sprite.play("shooting")
	elif velocity != Vector2.ZERO:
		animated_sprite.play("walking")
	else:
		animated_sprite.play("idle")
	
	look_at(get_global_mouse_position())
	rotate(PI/2)
	move_and_slide();




