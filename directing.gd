extends State

@export var unit : Cop

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		unit.pass_direction.emit()
	
