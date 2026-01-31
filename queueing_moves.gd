extends State

@export var unit : Unit

func enter(previous_state_path: String, data := {}) -> void:
	unit.get_node("ProjectionSprite").visible = true
	unit.get_node("ExplorationSprite").visible = true
	unit.get_node("UnitSprite").visible = false
	
	unit.get_node("ProjectionSprite").position = Vector2(0,0)
	unit.get_node("ExplorationSprite").position = Vector2(0,0)

func exit() -> void:
	unit.get_node("UnitSprite").visible = true
	unit.get_node("ProjectionSprite").visible = false
	unit.get_node("ExplorationSprite").visible = false


func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		var target_coordinate_x = unit.current_projection.x_coordinate
		var target_coordinate_y = unit.current_projection.y_coordinate - 1
		if check_if_legal_tile(target_coordinate_x, target_coordinate_y):
			unit.tile_change_requested.emit(target_coordinate_x, target_coordinate_y)
	
	if Input.is_action_just_pressed("move_down"):
		var target_coordinate_x = unit.current_projection.x_coordinate
		var target_coordinate_y = unit.current_projection.y_coordinate + 1
		if check_if_legal_tile(target_coordinate_x, target_coordinate_y):
			unit.tile_change_requested.emit(target_coordinate_x, target_coordinate_y)
	
	if Input.is_action_just_pressed("move_left"):
		var target_coordinate_x = unit.current_projection.x_coordinate - 1
		var target_coordinate_y = unit.current_projection.y_coordinate
		if check_if_legal_tile(target_coordinate_x, target_coordinate_y):
			unit.tile_change_requested.emit(target_coordinate_x, target_coordinate_y)
	
	if Input.is_action_just_pressed("move_right"):
		var target_coordinate_x = unit.current_projection.x_coordinate + 1
		var target_coordinate_y = unit.current_projection.y_coordinate
		if check_if_legal_tile(target_coordinate_x, target_coordinate_y):
			unit.tile_change_requested.emit(target_coordinate_x, target_coordinate_y)
	
	if Input.is_action_just_pressed("collect_food"):
		unit.request_step.emit(unit.current_exploration, "Collect")
	
	if Input.is_action_just_pressed("deposit_food"):
		unit.request_step.emit(unit.current_exploration, "Deposit")
	
	if Input.is_action_just_pressed("do_nothing"):
		unit.request_step.emit(unit.current_exploration, "Nothing")


func check_if_legal_tile(target_coordinate_x : int, target_coordinate_y : int):
	var current_unit_projection : Tile = unit.current_projection
	var distance_x = current_unit_projection.x_coordinate - target_coordinate_x
	var distance_y = current_unit_projection.y_coordinate - target_coordinate_y
	
	var vector_representation = Vector2(distance_x, distance_y)
	if vector_representation.length() == 1:
		return true
	else:
		return false
