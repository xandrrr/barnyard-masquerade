extends State

@export var unit : Cop

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		unit.action_confirmed.emit("Eat")
	
	if Input.is_action_just_pressed("inspect"):
		unit.action_confirmed.emit("Inspect")
	
	if Input.is_action_just_pressed("convict"):
		unit.action_confirmed.emit("Convict")
