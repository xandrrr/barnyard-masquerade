extends StateManager

@export var unit : Cop

func _ready() -> void:
	unit.starting_surveillance.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("Surveilling")
		state.enter(previous_state_path)
	)
	
	unit.unit_turn_started.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("QueueingCopMovement")
		state.enter(previous_state_path)
	)
	
	unit.unit_turn_concluded.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("Waiting")
		state.enter(previous_state_path)
	)
	
	unit.starting_player_targeting.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("TargetingPlayer")
		state.enter(previous_state_path)
	)
	
	unit.awaiting_confirmation.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("AwaitingConfirmation")
		state.enter(previous_state_path)
	)
	
	unit.awaiting_action.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("AwaitingAction")
		state.enter(previous_state_path)
	)
	
	unit.directing.connect(func():
		var previous_state_path := state.name
		state.exit()
		state = get_node("Directing")
		state.enter(previous_state_path)
	)
