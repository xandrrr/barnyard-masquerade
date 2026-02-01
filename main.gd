extends Node2D

var food_deposited_amount : int = 0
var current_turn : Unit = null

var current_steps : Dictionary = {
	1 : [],
	2 : [],
	3 : []
}
var current_players : Array = []
var current_player_units : Dictionary = {}
var current_npcs : Array = []

var current_turn_index = -1
var current_player_acting = null
var test_players = [
	1, 2, 3, 4
]

func _ready() -> void:
	$TileManager.create_map(3, 3)
	for test_player in test_players:
		current_player_units[test_player] = $UnitManager.create_player_unit()
		current_players.append(test_player)
	for i in range(8):
		var npc = $UnitManager.create_npc()
		current_npcs.append(npc)
	change_turn()


func update_deposited_food_tally():
	$MainControl/FoodDepositedLabel.text = "Food deposited: " + str(food_deposited_amount)


func prepare_new_turn():
	current_turn_index = -1
	current_player_acting = null
	current_steps[1].clear()
	current_steps[2].clear()
	current_steps[3].clear()
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
	prepare_new_turn()


func add_step(enactor : Unit, target_tile : Tile, action_name : String):
	var turn_elements = [enactor, target_tile, action_name]
	current_steps[enactor.steps_queued].append(turn_elements)


func play_step(step : Array):
	var unit = step[0]
	unit.position = unit.current_tile.position
	var tween = get_tree().create_tween()
	tween.tween_property(unit, "position", step[1].position, 1.0)
	unit.current_tile = step[1]
	match step[2]:
		"Collect":
			step[1].distribute_food(step[0], 2)
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


func _on_unit_manager_move_requested(enactor: Unit, target_tile: Tile, action_name: String) -> void:
	enactor.steps_queued += 1
	print(enactor.steps_queued)
	add_step(enactor, target_tile, action_name)
	enactor.get_node("ProjectionSprite").global_position = target_tile.position
	if enactor.steps_queued == 3:
		change_turn()


func change_turn():
	current_turn_index += 1
	if current_player_acting:
		var previous_unit = current_player_units[current_player_acting]
		previous_unit.unit_turn_concluded.emit()
		previous_unit.steps_queued = 0
	
	if current_turn_index < current_players.size():
		current_player_acting = current_players[current_turn_index]
		var current_unit = current_player_units[current_player_acting]
		current_unit.steps_queued = 0
		await get_tree().create_timer(0.05).timeout
		current_unit.unit_turn_started.emit()
	else:
		current_player_acting = null
		play_turn()
