extends CharacterBody2D

class_name zombie

const SPEED = 100
var hp = 100
var enemy_id: int
var can_attack = true
var attack_timer = Timer.new()
var damage_to_deal = 20
var is_dealing_damage: bool
@onready var animated_sprite = $AnimatedSprite2D

signal get_damage(enemy_id: int, current_hp: int)
signal add_score(amount)

func _ready():
	is_dealing_damage = false
	add_to_group("enemy")
	enemy_id = get_instance_id()
	print("Enemy " + str(enemy_id) + " spawned with " + str(hp) + " HP")
	print("Enemy " + str(enemy_id) + " has attack_barrier signal: " + str(has_signal("attack_barrier")))

func _on_attack_timer_timeout():
	can_attack = true

signal attack_barrier(damage: int, barrier: Node2D, enemy_id: int)

func attack(barrier):
	print("Enemy.attack called on enemy " + str(enemy_id) + " with barrier: " + str(barrier))
	if can_attack:
		print("Enemy " + str(enemy_id) + " is able to attack")
		print("Attempting to emit attack_barrier signal")
		var connected_signals = get_signal_connection_list("attack_barrier")
		print("Connected signals for attack_barrier: " + str(connected_signals))
		emit_signal("attack_barrier", 20, barrier, enemy_id)
		print("Signal emission attempted")
		can_attack = false
		attack_timer.start(2.0)
		print("Attack timer started for enemy " + str(enemy_id))
	else:
		print("Enemy " + str(enemy_id) + " cannot attack yet. Time left: " + str(attack_timer.time_left))

func deal_damage(damage: int, hit_enemy_id: int):
	if hit_enemy_id == enemy_id:
		hp -= damage
		emit_signal("get_damage", enemy_id, hp)
		if hp <= 0:
			emit_signal("add_score", 10)
			queue_free()
	else:
		print("Warning: Mismatched enemy ID. Expected " + str(enemy_id) + ", got " + str(hit_enemy_id))

func _process(_delta):
	Globals.zombieDamageAmount = damage_to_deal
	Globals.zombieDamageZone = $ZombieDamageArea
	
	if hp > 0 and Globals.playerAlive:
		look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	if Globals.playerAlive:
		if hp > 0:
			rotate(PI/2)
			var player_pos = Globals.player_pos
			var direction = (player_pos - global_position).normalized()
			velocity = direction * SPEED
			
			if velocity != Vector2.ZERO and !is_dealing_damage:
				animated_sprite.play("walking")
			elif is_dealing_damage:
				velocity = Vector2.ZERO
				animated_sprite.play("attack")
				await get_tree().create_timer(1.0).timeout
				animated_sprite.play("walking")
				velocity = direction * SPEED
		move_and_slide()
	else:
		await get_tree().create_timer(2.0).timeout
		animated_sprite.play("idle")

func _on_zombie_damage_area_area_entered(area):
	if area == Globals.playerHitbox:
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
