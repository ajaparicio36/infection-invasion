extends Control

var player_name: String

var curLineText: String

@onready var InsertName = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed():
	if Globals.player_name == "":
		InsertName.placeholder_text = "Enter a Name!"
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
