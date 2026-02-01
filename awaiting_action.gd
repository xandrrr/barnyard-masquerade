extends State

@export var unit : Cop

func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		unit.action_confirmed.emit("Eat")
		unit.action_finished.emit()
	if Input.is_action_just_pressed("inspect"):
		if check_for_valid_inspects():
			unit.action_confirmed.emit("Inspect")
	
	if Input.is_action_just_pressed("convict"):
		if check_for_valid_convicts():
			unit.action_confirmed.emit("Convict")


func check_for_valid_inspects():
	var valid_inspects = false
	var current_tile = unit.current_tile
	var quadrant_map = current_tile.quadrant_map
	for quadrant in current_tile.quadrant_map.keys():
		if quadrant_map[quadrant].occupant != null:
			if quadrant_map[quadrant].occupant.is_revealed == false:
				valid_inspects = true
				break
	
	return valid_inspects


func check_for_valid_convicts():
	var valid_convicts = false
	var current_tile = unit.current_tile
	var quadrant_map = current_tile.quadrant_map
	for quadrant in current_tile.quadrant_map.keys():
		if quadrant_map[quadrant].occupant != null:
			if quadrant_map[quadrant].occupant.is_revealed == true:
				valid_convicts = true
				break
	
	return valid_convicts
