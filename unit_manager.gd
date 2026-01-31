class_name UnitManager extends Node2D

@export var tile_manager : TileManager

const UNIT_PATH = preload("res://unit.tscn")
var current_units : Array = []

signal move_requested(enactor : Unit, target_tile : Tile, action_name : String)

func create_unit():
	var new_unit = UNIT_PATH.instantiate()
	add_child(new_unit)
	current_units.append(new_unit)
	
	tile_manager.get_tile_from_coordinates(1, 1).take_unit(new_unit)
	new_unit.current_tile = tile_manager.get_tile_from_coordinates(1, 1)
	new_unit.current_projection = tile_manager.get_tile_from_coordinates(1, 1)
	new_unit.tile_change_requested.connect(func(x_coord, y_coord): 
		var tile = tile_manager.get_tile_from_coordinates(x_coord, y_coord)
		if tile:
			tile.take_unit(new_unit)
	)
	
	new_unit.request_step.connect(func(tile : Tile, action_name : String): 
		move_requested.emit(new_unit, tile, action_name)
		new_unit.current_projection = tile
	)
	
	#new_unit.deposit_requested.connect(func():
		#var map_size_x = tile_manager.map_size_x
		#var map_size_y = tile_manager.map_size_y
		#if (
			#new_unit.current_tile.x_coordinate == map_size_x - 1 
			#or 
			#new_unit.current_tile.y_coordinate == map_size_y - 1
		#) and (
			#new_unit.current_tile.x_coordinate == 0 
			#or
			#new_unit.current_tile.y_coordinate == 0
		#):
			#food_deposited.emit(new_unit.food_amount)
			#new_unit.food_amount = 0
			#new_unit.update_food_tally()
	#)
	
	return new_unit
	
