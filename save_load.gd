extends Node

const SAVEFILE = "user://savefile.save"

var player_scores = {}  # Dictionary to hold scores for each player

func _ready():
	load_scores()

# Function to save all player scores
func save_scores():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	if file:
		var json_string = JSON.stringify(player_scores)  # Convert the dictionary to a JSON string
		file.store_string(json_string)
		file.close()
	else:
		print("Failed to open save file for writing")

# Function to load all player scores
func load_scores():
	if FileAccess.file_exists(SAVEFILE):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		if file:
			var json_data = file.get_as_text()  # Get the file content as a string
			player_scores = JSON.parse_string(json_data).result  # Parse the JSON string back into a dictionary
			file.close()
		else:
			print("Failed to open save file for reading")
	else:
		print("No save file found, starting with empty player scores.")

# Function to update a player's score
func update_score(player_name: String, new_score: int):
	player_scores[player_name] = new_score
	save_scores()  # Automatically save after updating

func get_score(player_name: String) -> int:
	return player_scores.get(player_name, 0)  # Return the player's score, or 0 if they don't
