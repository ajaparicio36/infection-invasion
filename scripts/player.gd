extends CharacterBody2D

var SPEED = 300.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("down"):
		velocity.y += SPEED
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("right"):
		velocity.x += SPEED
	if Input.is_action_pressed("run"):
		SPEED = 500
	else:
		SPEED = 300
	velocity = velocity.normalized() * SPEED
	
	if velocity != Vector2.ZERO:
		animated_sprite.play("walking")
	elif Input.is_action_pressed("melee"):
		animated_sprite.play("shooting")
	else:
		animated_sprite.play("idle")
	
	look_at(get_global_mouse_position())
	rotate(PI/2)
	move_and_slide();
	Globals.player_pos = global_position
	




