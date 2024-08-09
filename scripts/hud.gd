extends Control

@onready var hp_label = $HPLabel
@onready var weapon_label = $WeaponLabel
@onready var ammo_label = $AmmoLabel
@onready var score_label = $ScoreLabel
@onready var camera = get_viewport().get_camera_2d()
@onready var highest_score_label = $HighestScoreLabel

var hp = 100
var weapon = "Pistol"
var ammo = 10000000
var score = 0
var player_scores = {}

var highest_score: String


func _ready():
	load_scores()
	highest_score = get_highest_score_with_player_name()
	update_hud(hp, weapon, ammo, score, highest_score)
	var player_score = get_score(Globals.player_name)
	print(Globals.player_name, player_score, " SCORE")
	#print(get_highest_score_with_player_name(), "ASDASDASDASDS")

func update_hud(hp, weapon, ammo, score, highest_score = "0"):
	if ammo >= 1000000:
		ammo_label.text = "Ammo: Infinite"
	else:
		ammo_label.text = "Ammo: " + str(ammo)
	hp_label.text = "HP: " + str(hp)
	weapon_label.text = "Weapon: " + str(weapon)
	score_label.text = "Score: " + str(score)
	highest_score_label.text = str(highest_score)

func take_damage(lost_hp):
	hp -= lost_hp
	update_hud(hp, weapon, ammo, score)

func set_weapon(new_weapon):
	weapon = new_weapon
	update_hud(hp, weapon, ammo, score)

func set_ammo(new_ammo):
	ammo = new_ammo
	update_hud(hp, weapon, new_ammo, score)

func add_score(amount):
	score += amount
	update_hud(hp, weapon, ammo, score)
	update_score(Globals.player_name, score)

func _process(delta):
	if camera:
		global_position = camera.get_screen_center_position() - get_viewport_rect().size / 2

const SAVEFILE = "user://savefile.save"

func save_scores():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	if file:
		var json_string = JSON.stringify(player_scores)
		file.store_string(json_string)
		file.close()
		Globals.all_player_scores = player_scores
		print(Globals.all_player_scores, "ALLLLLLLLLL")
	else:
		print("Failed to open save file for writing")

func load_scores():
	if FileAccess.file_exists(SAVEFILE):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		if file:
			var json_data = file.get_as_text()
			player_scores = JSON.parse_string(json_data)
			file.close()
		else:
			print("Failed to open save file for reading")
	else:
		print("No save file found, starting with empty player scores.")

func update_score(player_name: String, new_score: int):
	if score > get_score(Globals.player_name):
		player_scores[player_name] = new_score
	
	save_scores()
	print(get_score(Globals.player_name), "UPDATEEEEEEEEE")

func get_score(player_name: String) -> int:
	return player_scores.get(player_name, 0)

func get_highest_score() -> int:
	if player_scores.size() > 0:
		print(player_scores.values())
		return player_scores.values().max()
	else:
		return 0

func get_highest_score_with_player_name() -> String:
	if player_scores.size() > 0:
		var max_key = player_scores.keys()[0]
		var max_score = player_scores[max_key]
		for key in player_scores.keys():
			var score = player_scores[key]
			if score > max_score:
				max_score = score
				max_key = key
		#return {"key": max_key, "score": max_score}
		return "Highest Score: " + str(max_score) + " by " + max_key
	else:
		return "0"

func get_all_score():
	if player_scores.size() > 0:
		return (player_scores.values())
	else:
		return 0
		
