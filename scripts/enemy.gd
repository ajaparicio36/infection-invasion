extends CharacterBody2D

const speed = 3

@onready var nav_agent = $NavigationAgent2D

var hp = 100

signal get_damage()

func deal_damage(damage):
	hp -= damage

func _process(_delta):
	if hp <= 0:
		queue_free()
	look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	var player_pos = Globals.player_pos
	var direction = (player_pos - position).normalized()
	velocity = direction * speed
	move_and_collide(velocity)
