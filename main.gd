extends Node2D

var food_deposited_amount : int = 0
var current_turn : Unit = null
var total_animals : Array = []
var animal_file_array : Array = []

var current_steps : Dictionary = {
	1 : [],
	2 : [],
	3 : []
}
var current_cop_steps : Array = []
var current_cop_step_index : int = 0

var current_players : Array = []
var current_player_units : Dictionary = {}
var current_npcs : Array = []
var current_cop : Cop = null

var current_turn_index = -1
var current_player_acting = null
var is_cop_movement : bool = false
var is_cop_surveillance : bool = false
var test_players = [
	1, 2, 3
]

var next_phase : String = "None"

func _ready() -> void:
	
	var player_select = await $CharacterSelect.playerSelect
	print(player_select)
	#cow, chicken, horse, goat, sheep, dog, cat, raccoon, donkey
	specificAnimalFile = iterate_for_animal_info(player_select)
	var player_dictionary = {
		1 : specificAnimalFile[0],
		2 :specificAnimalFile[1],
		3 : specificAnimalFile[2]
	}
	#
	total_animals = [""]
	#maybe to total animal dictionary, then based on incoming array, get the values associated with 
	#each animal and put to player?
	#then switch statement to match ids to information, no wait. why
	#do things with char select
	#{array[0]: 1, array[1]: 2, array[2]: 3, array[3]: 4}
	$TileManager.create_map(3, 3)
	for test_player in test_players:
		current_player_units[test_player] = $UnitManager.create_player_unit()
		current_players.append(test_player)
	for i in range(6):
		var npc = $UnitManager.create_npc()
		current_npcs.append(npc)
	current_cop = $UnitManager.create_cop()
	for tile in $TileManager.tiles:
		tile.update_food_tally()
	change_turn()
	
func iterate_for_animal_info(player_select):
	for i in range(player_select):
		var specificAnimalFile = find_info_related_to_animal(player_select)
		animalFileArray += specificAnimalFile
	return specificAnimalFile

func find_info_related_to_animal(player_select):
	for player in player_select:
		if player == "Cow":
			#assign files cow
		elif player == "Chicken":
			#load the files
		elif player == "Horse":
			#load the files
		elif player == "Goat":
			#load the files
		elif player == "Sheep":
			#load the files
		elif player == "Dog":
			#load the files
		elif player == "Cat":
			#load the files
		elif player == "Raccoon":
			#load the files
		elif player == "Donkey":
			#load the files
		else:
			pass
		return specific_files

func update_deposited_food_tally():
	$MainControl/InformationVBox/FoodDepositedLabel.text = "Food deposited: " + str(food_deposited_amount)


func prepare_new_turn():
	current_turn_index = -1
	current_cop_step_index = 0
	current_player_acting = null
	current_steps[1].clear()
	current_steps[2].clear()
	current_steps[3].clear()
	current_cop_steps.clear()
	
	for unit in $UnitManager.current_player_units:
		unit.unit_turn_concluded.emit()
	current_cop.unit_turn_concluded.emit()
	change_turn()


func play_turn():
	for unit in $UnitManager.current_player_units:
		unit.starting_dance.emit()
	for i in range(3):
		for step in current_steps[i + 1]:
			play_step(step)
		$UnitManager.move_all_npcs()
		await get_tree().create_timer(1.5).timeout
	update_deposited_food_tally()
	for tile in $TileManager.tiles:
		tile.update_food_tally()
	iterate_cop_movement()


func add_step(enactor : Unit, target_tile : Tile, action_name : String):
	var turn_elements = [enactor, target_tile, action_name]
	current_steps[enactor.steps_queued].append(turn_elements)


func play_step(step : Array):
	var unit = step[0]
	unit.dance_to_tile(step[1])
	match step[2]:
		"Collect":
			step[1].distribute_food(step[0], 1)
			unit.update_food_tally()
		"Deposit":
			var map_size_x = $TileManager.map_size_x
			var map_size_y = $TileManager.map_size_y
			if (
				step[1].x_coordinate == map_size_x - 1 
			or 
				step[1].y_coordinate == map_size_y - 1
			) and (
				step[1].x_coordinate == 0 
			or
				step[1].y_coordinate == 0
			):
				food_deposited_amount += unit.food_amount
				unit.food_amount = 0
				unit.update_food_tally()
		"Nothing":
			pass


func add_cop_step(enactor : Cop, target_tile : Tile, action_name : String):
	var turn_elements = [enactor, target_tile, action_name]
	current_cop_steps.append(turn_elements)


func play_cop_action(action_name : String):
	match action_name:
		"Eat":
			current_cop.current_tile.remove_food(2)
			current_cop.current_tile.update_food_tally()
		"Inspect":
			var instructions = """
			Available Actions:
			A (Right) - Confirm Inspection
			"""
			$MainControl/InformationVBox/InstructionsLabel.text = instructions
			var current_target_quadrant =  current_cop.current_tile.get_quadrant_from_coordinates(0,0)
			var reticle = current_cop.get_node("ReticleSprite")
			current_cop.current_target_quadrant = current_target_quadrant
			current_cop.starting_player_targeting.emit()
			reticle.visible = true
			reticle.global_position = current_target_quadrant.global_position
			var target_selected = false
			
			while target_selected == false:
				await current_cop.target_selected
				var target_character = current_cop.current_target_quadrant.occupant
				if target_character and !target_character.is_revealed:
					target_selected = true
					target_character.is_revealed = true
					target_character.get_node("UnitSprite").rotation_degrees = 180
					var message = str(target_character.name) + " has been revealed!"
					current_cop.directing.emit()
					display_message(message)
					await get_tree().create_timer(0.5).timeout
					await current_cop.pass_direction
					await get_tree().create_timer(0.5).timeout
			
			current_cop.action_finished.emit()
			reticle.visible = false
		"Convict":
			var instructions = """
			Available Actions:
			A (Right) - Confirm Conviction
			"""
			$MainControl/InformationVBox/InstructionsLabel.text = instructions
			var current_target_quadrant =  current_cop.current_tile.get_quadrant_from_coordinates(0,0)
			var reticle = current_cop.get_node("ReticleSprite")
			current_cop.current_target_quadrant = current_target_quadrant
			current_cop.starting_player_targeting.emit()
			reticle.visible = true
			reticle.global_position = current_target_quadrant.global_position
			var target_selected = false
			
			while target_selected == false:
				await current_cop.target_selected
				var target_character = current_cop.current_target_quadrant.occupant
				if target_character and target_character.is_revealed:
					target_selected = true
					target_character.is_eliminated = true
					target_character.visible = false
					if target_character.is_npc:
						var message = str(target_character.name) + " has been eliminated! They were an NPC."
						current_cop.directing.emit()
						display_message(message)
						await get_tree().create_timer(0.5).timeout
						await current_cop.pass_direction
						await get_tree().create_timer(0.5).timeout
					else:
						var message = str(target_character.name) + " has been eliminated! They were a player!"
						current_cop.directing.emit()
						display_message(message)
						await get_tree().create_timer(0.5).timeout
						await current_cop.pass_direction
						await get_tree().create_timer(0.5).timeout
			
			current_cop.action_finished.emit()
			reticle.visible = false
	current_cop.current_projection = current_cop.current_tile


func iterate_cop_movement():
	var instructions = """
	Choose one of your Surveilled rooms to act in:
	A (Right) - Select this room
	B (Btm) - Move to next Surveilled room
	"""
	$MainControl/InformationVBox/InstructionsLabel.text = instructions
	var step = current_cop_steps[current_cop_step_index]
	current_cop.position = current_cop.current_tile.position
	var tween = get_tree().create_tween()
	tween.tween_property(current_cop, "position", step[1].position, 1.0)
	current_cop.current_tile = step[1]
	await get_tree().create_timer(1.5).timeout
	current_cop_step_index += 1
	if current_cop_step_index < 3:
		current_cop.awaiting_confirmation.emit()
	else:
		var secondary_instructions = """
		Available Actions:
		Y (Left) - Destroy 2 food on tile
		Left Trigger - Inspect Dancer's identity
		Right Trigger - Convict revealed Dancer
		"""
		$MainControl/InformationVBox/InstructionsLabel.text = secondary_instructions
		step[1].take_cop(current_cop)
		current_cop.awaiting_action.emit()


func change_turn():
	if not is_cop_movement:
		current_turn_index += 1
		if current_player_acting:
			var previous_unit = current_player_units[current_player_acting]
			previous_unit.unit_turn_concluded.emit()
			previous_unit.steps_queued = 0
		
		if current_turn_index < current_players.size():
			current_player_acting = current_players[current_turn_index]
			var current_unit = current_player_units[current_player_acting]
			if not current_unit.is_eliminated:
				display_message("Next up: " + current_unit.name)
				
				#pause to confirm turn
				await get_tree().create_timer(0.5).timeout
				current_cop.directing.emit()
				await current_cop.pass_direction
				
				#start turn
				current_unit.steps_queued = 0
				await get_tree().create_timer(0.05).timeout
				current_unit.unit_turn_started.emit()
				$MainControl/InformationVBox/CurrentPlayerLabel.text = "Current Player : " + current_unit.name
				$MainControl/InformationVBox/InventoryLabel.text = "You have " + str(current_unit.food_amount) + " food."
				$MainControl/InformationVBox/RemainingStepsLabel.text = "Steps Remaining: 3"
				var instructions = """
				Available Actions:
				Y (Left) - Collect
				B (Btm) - Blend in (Do nothing)
				X (Top) - Deposit
				"""
				$MainControl/InformationVBox/InstructionsLabel.text = instructions
			else:
				change_turn()
		else:
			$MainControl/InformationVBox/CurrentPlayerLabel.text = "Current Player : The Cop"
			$MainControl/InformationVBox/InventoryLabel.text = "Stop them from collecting food!"
			$MainControl/InformationVBox/RemainingStepsLabel.text = "Steps Remaining: 3"
			var instructions = """
			Available Actions:
			A (Right) - Choose tile to Surveil
			"""
			$MainControl/InformationVBox/InstructionsLabel.text = instructions
			display_message("Next up: The Cop")
			current_cop.directing.emit()
			await get_tree().create_timer(0.5).timeout
			await current_cop.pass_direction
			current_player_acting = null
			is_cop_movement = true
			current_cop.steps_queued = 0
			await get_tree().create_timer(0.05).timeout
			current_cop.unit_turn_started.emit()
	else:
		is_cop_movement = false
		current_cop.unit_turn_concluded.emit()
		current_cop.steps_queued = 0
		$MainControl/InformationVBox/InstructionsLabel.text = ""
		display_message("Let's Dance!")
		#pause to confirm everyone is ready
		await get_tree().create_timer(0.5).timeout
		current_cop.directing.emit()
		await current_cop.pass_direction
		await get_tree().create_timer(0.5).timeout
		play_turn()


func display_board():
	display_message("Results")
	$MainControl/InformationVBox/InstructionsLabel.text = ""
	await get_tree().create_timer(1.0).timeout
	current_cop.directing.emit()
	await current_cop.pass_direction
	
	await get_tree().create_timer(0.5).timeout
	current_cop.directing.emit()
	await current_cop.pass_direction
	check_for_winner()


func check_for_winner():
	var total_food_amount = 0
	for tile in $TileManager.tiles:
		total_food_amount += tile.food_amount
	total_food_amount += current_player_units[1].food_amount
	total_food_amount += current_player_units[2].food_amount
	total_food_amount += current_player_units[3].food_amount
	total_food_amount += food_deposited_amount
	
	if food_deposited_amount >= 35:
		display_message("35 food has been delivered. The Robbers win!")
		await get_tree().create_timer(1.0).timeout
		current_cop.directing.emit()
		await current_cop.pass_direction
	
	var players_remaining : int = 3
	for unit in current_player_units.keys():
		if current_player_units[unit].is_eliminated:
			players_remaining -= 1
	
	if players_remaining == 0:
		display_message("No Robbers remain. The Cop wins!")
		await get_tree().create_timer(1.0).timeout
		current_cop.directing.emit()
		await current_cop.pass_direction
	elif total_food_amount < 35:
		display_message("Not enough food remains. The Cop wins!")
		await get_tree().create_timer(1.0).timeout
		current_cop.directing.emit()
		await current_cop.pass_direction
	else:
		prepare_new_turn()


func display_message(phase_text : String):
	await get_tree().create_timer(0.05).timeout
	current_cop.directing.emit()
	$MainControl/PhasePanel/CenterContainer/PhaseLabel.text = phase_text
	$PhaseAnimator.play("fade_phase_in")
	await get_tree().create_timer(0.5).timeout
	await current_cop.pass_direction
	$PhaseAnimator.play("fade_phase_out")


func _on_unit_manager_move_requested(enactor: Unit, target_tile: Tile, action_name: String) -> void:
	if !(enactor.current_projection == target_tile):
		enactor.steps_queued += 1
		print(enactor.steps_queued)
		add_step(enactor, target_tile, action_name)
		enactor.get_node("ProjectionSprite").global_position = target_tile.position
		if enactor.steps_queued == 3:
			change_turn()
		else: 
			var remaining_moves = 3 - enactor.steps_queued
			$MainControl/InformationVBox/RemainingStepsLabel.text = "Steps Remaining: " + str(remaining_moves)


func _on_unit_manager_cop_move_requested(enactor: Cop, target_tile: Tile, action_name: String) -> void:
	if !(enactor.current_projection == target_tile):
		enactor.steps_queued += 1
		add_cop_step(enactor, target_tile, action_name)
		enactor.get_node("ProjectionSprite").global_position = target_tile.position
		if enactor.steps_queued == 3:
			change_turn()
		else: 
			var remaining_moves = 3 - enactor.steps_queued
			$MainControl/InformationVBox/RemainingStepsLabel.text = "Steps Remaining: " + str(remaining_moves)


func _on_unit_manager_cop_room_decision(decision: bool) -> void:
	var instructions = """
	Available Actions:
	Y (Left) - Destroy 2 food on tile
	Left Trigger - Inspect Dancer's identity
	Right Trigger - Convict revealed Dancer
	"""
	$MainControl/InformationVBox/InstructionsLabel.text = instructions
	if decision:
		current_cop.awaiting_action.emit()
	else:
		iterate_cop_movement()


func _on_unit_manager_cop_action_decided(action_name: String) -> void:
	play_cop_action(action_name)
	if action_name != "Eat":
		await current_cop.action_finished
	await get_tree().create_timer(0.05).timeout
	display_board()
