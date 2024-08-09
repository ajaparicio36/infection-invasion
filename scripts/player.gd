extends CharacterBody2D

var SPEED = 300.0
var hp = 100
var max_hp = 100
var min_hp = 0
var can_take_damage: bool
var dead: bool
var ammo_count = 0  # Add ammo count
var nearest_barrier: Node2D = null
const REPAIR_DISTANCE = 100.0  # Adjust this value as needed

@onready var animated_sprite = $AnimatedSprite2D


signal set_hp(lost_hp)
signal add_ammo(weapon_name, amount)

func _ready():
	
	dead = false
	can_take_damage = true
	Globals.playerAlive = true

func _physics_process(_delta):
	Globals.playerHitbox = $Area2D
	if !dead:
		handle_movement()
		check_hitbox()
	move_and_slide()
	Globals.player_pos = global_position
	
func handle_movement():
	velocity = Vector2.ZERO
	check_nearest_barrier()
	if Input.is_action_just_pressed("repair") and nearest_barrier:
		repair_barrier()
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

func check_nearest_barrier():
	nearest_barrier = null
	var shortest_distance = REPAIR_DISTANCE
	
	for barrier in get_tree().get_nodes_in_group("barrier"):
		var distance = global_position.distance_to(barrier.global_position)
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_barrier = barrier

func repair_barrier():
	if nearest_barrier and nearest_barrier.is_destroyed:
		nearest_barrier.repair()
		print("Player repaired a barrier!")

func check_hitbox():
	var hitbox_areas = $Area2D.get_overlapping_areas()
	var damage: int = 0  # Initialize damage to zero
	if hitbox_areas:
		for area in hitbox_areas:
			var parent = area.get_parent()
			if parent is zombie:
				damage = Globals.zombieDamageAmount
			elif parent is zombie_brute:
				damage = Globals.bruteDamageAmount
			elif parent is zombie_sprinter:
				damage = Globals.sprinterDamageAmount
			elif parent is ammo:  # Check for ammo pickup
				pick_up_ammo(parent)

	if can_take_damage and damage > 0:
		take_damage(damage)

func take_damage(damage):
	if damage != 0:
		if hp > 0:
			hp -= damage
			emit_signal("set_hp", damage)
			print("player hp: ", hp)
			if hp <= 0:
				hp = 0
				dead = true
				Globals.playerAlive = false
				handle_death()
			take_damage_cooldown(1.0)
			
func handle_death():
	# Here you could trigger a game over screen or animation
	await get_tree().create_timer(2.0).timeout
	self.queue_free()

func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true

func pick_up_ammo(ammo):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var random_value = rng.randf()
	var weapon:int
	
	if random_value < 0.40:  # 50% chance for 2
		weapon = 2
	elif random_value < 0.80:  # 25% chance for 3
		weapon = 3
	else:  # 25% chance for 4
		weapon = 4
	
	if weapon == 2:
		emit_signal("add_ammo", "Rifle", 60)
	elif weapon == 3:
		emit_signal("add_ammo", "Shotgun", 12)
	else:
		emit_signal("add_ammo", "Sniper", 5)
	print("Ammo picked up for weapon ", weapon)
	ammo.queue_free()  # Remove ammo from the scene after pickup
