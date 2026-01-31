extends Node2D

var food_deposited_amount : int = 0
var current_turn = []

func _ready() -> void:
	$TileManager.create_map(3, 3)
	$UnitManager.create_unit()
	update_queued_move_display()


func update_deposited_food_tally():
	$MainControl/FoodDepositedLabel.text = "Food deposited: " + str(food_deposited_amount)


func play_turn():
	for step in current_turn:
		play_step(step)
	current_turn.clear()
	update_queued_move_display()


func add_step(enactor : Unit, target_tile : Tile, action_name : String):
	var turn_elements = [enactor, target_tile, action_name]
	current_turn.append(turn_elements)
	update_queued_move_display()
	if current_turn.size() == 3:
		play_turn()


func play_step(step : Array):
	print(step[2])
#	use a switch statement to match name to behavior


func _on_unit_manager_move_requested(enactor: Unit, target_tile: Tile, action_name: String) -> void:
	add_step(enactor, target_tile, action_name)


func update_queued_move_display():
	if !current_turn.is_empty():
		var to_append : String = "\n"
		for step in current_turn:
			to_append += step[2]
			to_append += "\n"
		$MainControl/StepsQueuedLabel.text = "Current steps queued: " + to_append
	else:
		$MainControl/StepsQueuedLabel.text = "No steps queued"
