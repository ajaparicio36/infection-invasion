extends CharacterBody2D

const speed = 75
var hp = 150
var enemy_id: int

func _ready():
	add_to_group("enemy")
	enemy_id = get_instance_id()
	print("brute ", str(enemy_id), "spawned with ", str(hp), " HP")

func _process(_delta):
	look_at(Globals.player_pos)

func _physics_process(_delta: float) -> void:
	rotate(PI/2)
	var player_pos = Globals.player_pos
	var direction = (player_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide() 
