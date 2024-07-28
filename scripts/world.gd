extends Node2D  # or whatever your main scene extends

@onready var weapon = $Player/Weapon
@onready var hud = $HUD

var current_wave: int
@export var zombie: PackedScene

var starting_nodes: int 
var current_nodes: int
var wave_spawn_ended

func _ready():
	weapon.connect("take_damage", Callable(hud, "take_damage"))
	weapon.connect("set_weapon", Callable(hud, "set_weapon"))
	weapon.connect("set_ammo", Callable(hud, "set_ammo"))
	
	current_wave = 0
	Globals.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()
	
func position_to_next_wave():
	if current_nodes == starting_nodes:
		current_wave += 1
		Globals.current_wave = current_wave
		prepare_spawn("zombie", 2.0, 2.0)
		print(current_wave)

func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time: float = 2.0
	print("mob_amount: ", mob_amount)
	var mob_spawn_rounds = mob_amount / mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "zombie":
		var zombie_spawn1 = $SpawnPoint1
		var zombie_spawn2 = $SpawnPoint2
		var zombie_spawn3 = $SpawnPoint3
		var zombie_spawn4 = $SpawnPoint4
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var zombie1 = zombie.instantiate()
				zombie1.global_position = zombie_spawn1.global_position
				var zombie2 = zombie.instantiate()
				zombie2.global_position = zombie_spawn2.global_position
				var zombie3 = zombie.instantiate()
				zombie3.global_position = zombie_spawn3.global_position
				var zombie4 = zombie.instantiate()
				zombie4.global_position = zombie_spawn4.global_position
				add_child(zombie1)
				add_child(zombie2)
				add_child(zombie3)
				add_child(zombie4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
		wave_spawn_ended = true
