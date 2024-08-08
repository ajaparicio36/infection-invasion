extends CharacterBody2D

var SPEED = 300.0
var hp = 100
var max_hp = 100
var min_hp = 0
var can_take_damage: bool
var dead: bool

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	dead = false
	can_take_damage = true
	Globals.playerAlive = true

func _physics_process(_delta):
	Globals.playerHitbox = $Area2D
	if !dead:
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
		check_hitbox()
	move_and_slide();
	Globals.player_pos = global_position
	
func check_hitbox():
	var hitbox_areas = $Area2D.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is zombie:
			damage = Globals.zombieDamageAmount
		elif hitbox.get_parent() is zombie_brute:
			damage = Globals.bruteDamageAmount
		elif hitbox.get_parent() is zombie_sprinter:
			damage = Globals.sprinterDamageAmount
		
	
	if can_take_damage:
		take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if hp > 0:
			hp -= damage
			print("player hp: ", hp)
			if hp <= 0:
				hp = 0
				dead = true
				Globals.playerAlive = false
				# handle game over or death animation; sample:
				handle_death()
			take_damage_cooldown(1.0)
			
func handle_death():
	await get_tree().create_timer(2.0).timeout
	self.queue_free()

func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true

