extends State

@export var unit : Cop


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		var target_x_coord = unit.current_target_quadrant.x_coord
		var target_y_coord = unit.current_target_quadrant.y_coord - 1
		var quadrant = unit.current_tile.get_quadrant_from_coordinates(target_x_coord, target_y_coord)
		if quadrant:
			unit.current_target_quadrant = quadrant
			unit.get_node("ReticleSprite").global_position = quadrant.global_position
	
	if Input.is_action_just_pressed("move_down"):
		var target_x_coord = unit.current_target_quadrant.x_coord
		var target_y_coord = unit.current_target_quadrant.y_coord + 1
		var quadrant = unit.current_tile.get_quadrant_from_coordinates(target_x_coord, target_y_coord)
		if quadrant:
			unit.current_target_quadrant = quadrant
			unit.get_node("ReticleSprite").global_position = quadrant.global_position
	
	if Input.is_action_just_pressed("move_left"):
		var target_x_coord = unit.current_target_quadrant.x_coord - 1
		var target_y_coord = unit.current_target_quadrant.y_coord
		var quadrant = unit.current_tile.get_quadrant_from_coordinates(target_x_coord, target_y_coord)
		if quadrant:
			unit.current_target_quadrant = quadrant
			unit.get_node("ReticleSprite").global_position = quadrant.global_position
	
	if Input.is_action_just_pressed("move_right"):
		var target_x_coord = unit.current_target_quadrant.x_coord + 1
		var target_y_coord = unit.current_target_quadrant.y_coord
		var quadrant = unit.current_tile.get_quadrant_from_coordinates(target_x_coord, target_y_coord)
		if quadrant:
			unit.current_target_quadrant = quadrant
			unit.get_node("ReticleSprite").global_position = quadrant.global_position
	
	if Input.is_action_just_pressed("confirm"):
		unit.target_selected.emit()
