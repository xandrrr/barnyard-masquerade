extends Control

@onready var player_label: Label = $playerNumLabel2
var selected_player = null
var player_selection: Array[String] = []
var count = 0

#if player clicks character button, display animal name chosen
#if player hits confirm button below, store player selected and make button no longer selectable as
#other players pick their character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#button presses

func _on_character_1_pressed() -> void:
	selected_player = "Cow"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_2_pressed() -> void:
	selected_player = "Chicken"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_3_pressed() -> void:
	selected_player = "Horse"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_4_pressed() -> void:
	selected_player = "Goat"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_5_pressed() -> void:
	selected_player = "Sheep"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_6_pressed() -> void:
	selected_player = "Donkey"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_7_pressed() -> void:
	selected_player = "Dog"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_8_pressed() -> void:
	selected_player = "Cat"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_9_pressed() -> void:
	selected_player = "Llama"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_10_pressed() -> void:
	selected_player = "Racoon"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body


func _on_character_11_pressed() -> void:
	selected_player = "Groundhog"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_character_12_pressed() -> void:
	selected_player = "Badger"
	player_label.text = "Player:  " + selected_player
	pass # Replace with function body.


func _on_confirm_button_pressed() -> void:
	#for each character, assign a place in array to pass on to turn functionality
	if selected_player == null:
		pass
	else:
		player_selection.append(selected_player)
		count += 1
		if count == 5:
			print(player_selection)
			#get_tree().change_scene_to_file("res://main.tscn")
		
