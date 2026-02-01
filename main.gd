extends Node2D

var food_deposited_amount : int = 0
var current_turn : Unit = null

var current_steps : Array = []

func _ready() -> void:
	
	var player_select = await $CharacterSelect.playerSelect
	print(player_select)
	var player_dictionary = {
		player_select[0]: 1,
		player_select[1]: 2,
		player_select[2]: 3
	}
	#do things with char select
	#{array[0]: 1, array[1]: 2, array[2]: 3, array[3]: 4}
	$TileManager.create_map(3, 3)
	$UnitManager.create_player_unit()
	update_queued_move_display()


func update_deposited_food_tally():
	$MainControl/FoodDepositedLabel.text = "Food deposited: " + str(food_deposited_amount)


func play_turn():
	for unit in $UnitManager.current_player_units:
		unit.starting_dance.emit()
	for step in current_steps:
		play_step(step)
		await get_tree().create_timer(1.0).timeout
	current_steps.clear()
	update_queued_move_display()
	update_deposited_food_tally()
	for unit in $UnitManager.current_player_units:
		unit.unit_turn_started.emit()


func add_step(enactor : Unit, target_tile : Tile, action_name : String):
	var turn_elements = [enactor, target_tile, action_name]
	current_steps.append(turn_elements)
	update_queued_move_display()
	if current_steps.size() == 3:
		play_turn()


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
	add_step(enactor, target_tile, action_name)
	enactor.get_node("ProjectionSprite").global_position = target_tile.position


func update_queued_move_display():
	if !current_steps.is_empty():
		var to_append : String = "\n"
		for step in current_steps:
			to_append += step[2]
			to_append += "\n"
		$MainControl/StepsQueuedLabel.text = "Current steps queued: " + to_append
	else:
		$MainControl/StepsQueuedLabel.text = "No steps queued"
