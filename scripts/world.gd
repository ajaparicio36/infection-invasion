extends Node2D

@onready var weapon = $HouseMap/Player/Weapon
@onready var player = $HouseMap/Player
@onready var hud = $HUD
var current_wave: int
@export var zombie: PackedScene
@export var zombie_brute: PackedScene
@export var zombie_sprinter: PackedScene
var starting_nodes: int
var current_nodes: int
var wave_spawn_ended

func _ready():
	weapon.connect("take_damage", Callable(hud, "take_damage"))
	weapon.connect("set_weapon", Callable(hud, "set_weapon"))
	weapon.connect("set_ammo", Callable(hud, "set_ammo"))
	weapon.connect("bullet_hit", Callable(self, "_on_weapon_bullet_hit"))
	player.connect("set_hp", Callable(hud, "set_hp"))
	player.connect("add_ammo", Callable(weapon, "add_ammo"))
	
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
	current_wave = 0
	Globals.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()

func position_to_next_wave():
	if current_nodes == starting_nodes:
		wave_spawn_ended = false
		current_wave += 1
		Globals.current_wave = current_wave
		prepare_spawn("zombie", 2.0, 2.0)
		prepare_spawn("zombie_brute", 1.5, 2.0)
		prepare_spawn("zombie_sprinter", 0.5, 2.0)
		print(current_wave)

func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time: float = 2.0
	print(type, ":", mob_amount)
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
				zombie1.connect("add_score", Callable(hud, "add_score"))
				zombie1.global_position = zombie_spawn1.global_position
				var zombie2 = zombie.instantiate()
				zombie2.connect("add_score", Callable(hud, "add_score"))
				zombie2.global_position = zombie_spawn2.global_position
				var zombie3 = zombie.instantiate()
				zombie3.global_position = zombie_spawn3.global_position
				zombie3.connect("add_score", Callable(hud, "add_score"))
				var zombie4 = zombie.instantiate()
				zombie4.global_position = zombie_spawn4.global_position
				zombie4.connect("add_score", Callable(hud, "add_score"))
				add_child(zombie1)
				add_child(zombie2)
				add_child(zombie3)
				add_child(zombie4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "zombie_brute":
		var brute_spawn1 = $BruteSpawnPoint1
		var brute_spawn2 = $BruteSpawnPoint2
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var brute1 = zombie_brute.instantiate()
				brute1.connect("add_score", Callable(hud, "add_score"))
				brute1.global_position = brute_spawn1.global_position
				var brute2 = zombie_brute.instantiate()
				brute2.connect("add_score", Callable(hud, "add_score"))
				brute2.global_position = brute_spawn2.global_position
				add_child(brute1)
				add_child(brute2)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	elif type == "zombie_sprinter":
		var sprinter_spawn1 = $SprinterSpawnPoint1
		var sprinter_spawn2 = $SprinterSpawnPoint2
		var sprinter_spawn3 = $SprinterSpawnPoint3
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var sprinter1 = zombie_sprinter.instantiate()
				sprinter1.global_position = sprinter_spawn1.global_position
				var sprinter2 = zombie_sprinter.instantiate()
				sprinter2.global_position = sprinter_spawn2.global_position
				var sprinter3 = zombie_sprinter.instantiate()
				sprinter3.global_position = sprinter_spawn3.global_position 
				add_child(sprinter1)
				add_child(sprinter2)
				add_child(sprinter3)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
	wave_spawn_ended = true

func _on_weapon_bullet_hit(damage: int, enemy_id: int):
	var enemy = instance_from_id(enemy_id)
	if enemy and enemy.has_method("deal_damage"):
		enemy.deal_damage(damage, enemy_id)

func _process(_delta):
	current_nodes = get_child_count()
	if wave_spawn_ended:
		position_to_next_wave()
