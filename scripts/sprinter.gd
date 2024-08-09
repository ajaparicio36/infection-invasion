extends CharacterBody2D

const SPEED = 200
var hp = 70
var enemy_id: int

@onready var animated_sprite = $AnimatedSprite2D

signal get_damage(enemy_id: int, current_hp: int)
signal add_score(amount)

func _ready():
	add_to_group("enemy")
	enemy_id = get_instance_id()
	print("Enemy " + str(enemy_id) + " spawned with " + str(hp) + " HP")

func deal_damage(damage: int, hit_enemy_id: int):
	if hit_enemy_id == enemy_id:
		hp -= damage
		emit_signal("get_damage", enemy_id, hp)
		print("Enemy " + str(enemy_id) + " took " + str(damage) + " damage. HP: " + str(hp))
		if hp <= 0:
			print("Enemy " + str(enemy_id) + " is being removed")
			emit_signal("add_score", 20)
			queue_free()
	else:
		print("Warning: Mismatched enemy ID. Expected " + str(enemy_id) + ", got " + str(hit_enemy_id))

func _process(delta):
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

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		# The damage will be handled through the "bullet_hit" signal in the weapon script
		pass  # We don't queue_free() the bullet here anymore, it's done in the bullet script
