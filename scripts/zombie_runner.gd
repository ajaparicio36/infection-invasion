extends CharacterBody2D

const speed = 310
var hp = 50
var enemy_id: int 

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	pass 

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
