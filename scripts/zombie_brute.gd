extends CharacterBody2D

const SPEED = 60
var hp = 150
var enemy_id: int
var can_attack = true
var attack_timer = Timer.new()
@onready var animated_sprite = $AnimatedSprite2D

signal get_damage(enemy_id: int, current_hp: int)
signal add_score(amount)

func _ready():
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	attack_timer.set_one_shot(true)
	add_to_group("enemy")
	enemy_id = get_instance_id()

func _on_attack_timer_timeout():
	can_attack = true

signal attack_barrier(damage: int, barrier: Node2D)  # Modified signal

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
			emit_signal("add_score", 30)
			queue_free()
	else: 
		print("Warning: Mismatched enemy ID. Expected " + str(enemy_id) + ", got " + str(hit_enemy_id))

func _process(_delta):
	if hp > 0:
		look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	if hp > 0:
		rotate(PI/2)
		var player_pos = Globals.player_pos
		var direction = (player_pos - global_position).normalized()
		velocity = direction * SPEED
		
		if velocity != Vector2.ZERO:
			animated_sprite.play("walking")
		else:
			animated_sprite.play("idle")
		
		move_and_slide()

