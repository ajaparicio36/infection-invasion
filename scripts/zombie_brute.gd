extends CharacterBody2D

class_name zombie_brute

const SPEED = 60
var hp = 150
var enemy_id: int
var can_attack = true
var attack_timer = Timer.new()
var damage_to_deal = 25
var is_dealing_damage: bool
@onready var animated_sprite = $AnimatedSprite2D

var current_target: Node2D
var is_attacking_barrier: bool = false
var destroyed_barriers = []

signal get_damage(enemy_id: int, current_hp: int)
signal add_score(amount)

func _ready():
	is_dealing_damage = false
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	attack_timer.set_one_shot(true)
	add_to_group("enemy")
	enemy_id = get_instance_id()

func _on_attack_timer_timeout():
	can_attack = true

func deal_damage(damage: int, hit_enemy_id: int):
	if hit_enemy_id == enemy_id:
		hp -= damage
		emit_signal("get_damage", enemy_id, hp)
		if hp <= 0:
			emit_signal("add_score", 30)
			queue_free()
	else: 
		print("Warning: Mismatched enemy ID. Expected " + str(enemy_id) + ", got " + str(hit_enemy_id))

func _process(_delta):
	Globals.bruteDamageAmount = damage_to_deal
	Globals.bruteDamageZone = $BruteDamageArea
	
	if hp > 0 and Globals.playerAlive:
		look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	if Globals.playerAlive:
		if hp > 0:
			rotate(PI/2)
			var target_pos = get_target_position()
			var direction = (target_pos - global_position).normalized()
			velocity = direction * SPEED
			
			if velocity != Vector2.ZERO and !is_dealing_damage and !is_attacking_barrier:
				animated_sprite.play("walking")
			elif is_dealing_damage or is_attacking_barrier:
				velocity = Vector2.ZERO
				animated_sprite.play("attack")
			
			move_and_slide()
		else:
			await get_tree().create_timer(2.0).timeout
			animated_sprite.play("idle")

func get_target_position() -> Vector2:
	var barriers = get_tree().get_nodes_in_group("barrier")
	var nearest_barrier = null
	var nearest_distance = INF
	
	for barrier in barriers:
		if barrier not in destroyed_barriers:
			var distance = global_position.distance_to(barrier.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_barrier = barrier
	
	if nearest_barrier and nearest_distance < global_position.distance_to(Globals.player_pos):
		current_target = nearest_barrier
		return nearest_barrier.global_position
	else:
		current_target = null
		return Globals.player_pos

func attack_barrier(barrier):
	if !is_attacking_barrier and barrier not in destroyed_barriers:
		is_attacking_barrier = true
		while barrier.hp > 0 and is_instance_valid(barrier) and !barrier.is_destroyed:
			barrier.take_damage(damage_to_deal, enemy_id)
			await get_tree().create_timer(1.0).timeout
		is_attacking_barrier = false

func on_barrier_destroyed(barrier):
	if barrier in destroyed_barriers:
		return
	destroyed_barriers.append(barrier)
	if current_target == barrier:
		# Immediately recalculate path
		velocity = Vector2.ZERO
		current_target = null

func _on_brute_damage_area_area_entered(area):
	if area == Globals.playerHitbox:
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
	elif area.get_parent().is_in_group("barrier") and area.get_parent() not in destroyed_barriers:
		attack_barrier(area.get_parent())
