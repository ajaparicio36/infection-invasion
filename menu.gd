extends Control

var player_name: String

var curLineText: String
const SAVEFILE = "user://savefile.save"
var player_scores = {}

@onready var InsertName = $LineEdit
@onready var LeaderBoard = $LeaderBoard

func _ready():
	$VBoxContainer/StartButton.grab_focus()
	load_scores()
	get_sorted_scores(player_scores)


func _on_start_button_pressed():
	if Globals.player_name == "":
		InsertName.placeholder_text = "Enter  a  Name!"
		InsertName.grab_focus()
	else:
		get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

 
func _on_line_edit_text_submitted(new_text):
	Globals.player_name = new_text
	print(Globals.player_name)


func _on_ok_button_pressed():
	_on_line_edit_text_submitted(curLineText)


func _on_line_edit_text_changed(new_text):
	curLineText = new_text


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func get_sorted_scores(dict_score):
	var sorted_scores = []
	
	#Bubble Sort, I used custom sort as Godot provided sort is not good for sorting dictionary
	if dict_score.size() > 0:
		for key in dict_score.keys():
			sorted_scores.append({"key": key, "score": dict_score[key]})
		
		var n = sorted_scores.size()
		for i in range(n):
			for j in range(0, n-i-1):
				if sorted_scores[j]["score"] < sorted_scores[j+1]["score"]:
					var temp = sorted_scores[j]
					sorted_scores[j] = sorted_scores[j+1]
					sorted_scores[j+1] = temp
					
	var i: int = 1
	var max_display: int = min(10, sorted_scores.size())
	for idx in range(max_display):
		var item = sorted_scores[idx]
		LeaderBoard.add_text(str(i) + '.' + str(item["key"]) + ": " + str(item["score"]) + "\n")
		i+=1

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
