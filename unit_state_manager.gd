extends StateManager

@export var unit : Unit

func _ready() -> void:
	unit.starting_dance.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("Dancing")
		state.enter(previous_state_path)
	)
	
	unit.unit_turn_started.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("QueueingMoves")
		state.enter(previous_state_path)
	)
	
	unit.unit_turn_concluded.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("Waiting")
		state.enter(previous_state_path)
	)
