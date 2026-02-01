extends State

@export var unit : Cop

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		unit.landing_decided.emit(true)
	
	if Input.is_action_just_pressed("deny"):
		unit.landing_decided.emit(false)
