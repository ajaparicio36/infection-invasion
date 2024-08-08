extends CharacterBody2D

class_name zombie_sprinter

const speed = 310
var hp = 50
var enemy_id: int
var can_attack = true
var attack_timer = Timer.new()
var damage_to_deal = 15
var is_dealing_damage: bool

@onready var animated_sprite = $AnimatedSprite2D

signal get_damage(enemy_id: int, current_hp: int)
signal add_score(amount)

func _ready():
	is_dealing_damage = false
	add_to_group("enemy")
	enemy_id = get_instance_id()
	
func _on_attack_timer_timeout():
	can_attack = true

signal attack_barrier(damage: int, barrier: Node2D)

func attack(barrier):
	print("Enemy.attack called with barrier: " + str(barrier))
	if can_attack:
		print("Enemy " + str(enemy_id) + " attacking barrier")
		emit_signal("attack_barrier", 20, barrier)  # Changed to pass the barrier directly
		can_attack = false
		attack_timer.start(2.0)
	else:
		print("Enemy " + str(enemy_id) + " cannot attack yet")

func deal_damage(damage: int, hit_enemy_id: int):
	if hit_enemy_id == enemy_id:
		hp -= damage
		emit_signal("get_damage", enemy_id, hp)
		if hp <= 0:
			emit_signal("add score", 30)
			queue_free()
	else:
		print("Warning: Mismatched enemy ID. Expected " + str(enemy_id) + ", got " + str(hit_enemy_id))

func _process(_delta):
	Globals.sprinterDamageAmount = damage_to_deal
	Globals.sprinterDamageZone = $SprinterDamageArea
	
	if hp > 0:
		look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	if Globals.playerAlive:
		if hp > 0:
			rotate(PI/2)
			var player_pos = Globals.player_pos
			var direction = (player_pos - global_position).normalized()
			velocity = direction * speed
			
			if velocity != Vector2.ZERO and !is_dealing_damage:
				animated_sprite.play("walking")
			elif is_dealing_damage:
				velocity = Vector2.ZERO
				animated_sprite.play("attacking")
				await get_tree().create_timer(1.0).timeout
				animated_sprite.play("walking")
				velocity = direction * speed
		move_and_slide()
	else:
		await get_tree().create_timer(2.0).timeout
		animated_sprite.play("idle")

func _on_sprinter_damage_area_area_entered(area):
	if area == Globals.playerHitbox:
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
