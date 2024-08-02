extends CharacterBody2D

const speed = 60
var hp = 150
var enemy_id: int

@onready var animated_sprite = $AnimatedSprite2D

signal get_damage(enemy_id: int, current_hp: int)

func _ready():
	add_to_group("enemy")
	enemy_id = get_instance_id()
	print("Brute ", enemy_id, " spawned with ", str(hp), " HP")

func deal_damage(damage: int, hit_enemy_id: int):
	if hit_enemy_id == enemy_id:
		hp -= damage
		emit_signal("get_damage", enemy_id, hp)
		print("Brute ", str(enemy_id), " took ", str(damage), " damage. HP: ", str(hp))
		if hp <= 0:
			print("Brute ", str(enemy_id), " is being removed")
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
		velocity = direction * speed
		
		if velocity != Vector2.ZERO:
			animated_sprite.play("walking")
		else:
			animated_sprite.play("idle")
		
		move_and_slide()

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		pass


