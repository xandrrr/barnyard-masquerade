class_name StateManager extends Node

@export var initial_state : State = null

@onready var state : State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else self.get_child(0)
).call()


func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	
	await owner.ready
	state.enter("")


func _transition_to_next_state(target_state_path : String, data : Dictionary = {}) -> void:
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
