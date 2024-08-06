extends CharacterBody2D

class_name zombie_sprinter

const speed = 310
var hp = 50
var enemy_id: int
var damage_to_deal = 15
var is_dealing_damage: bool

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	is_dealing_damage = false

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
