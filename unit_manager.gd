class_name UnitManager extends Node2D

@export var tile_manager : TileManager

const UNIT_PATH = preload("res://unit.tscn")
var current_player_units : Array = []
var current_npcs : Array = []
var player_select_string: Array =  []
#make variable go into here?
#or, assign each to a num
var test_players = [
	1, 2, 3, 4
]

signal move_requested(enactor : Unit, target_tile : Tile, action_name : String)

func create_player_unit():
	var new_unit = UNIT_PATH.instantiate()
	add_child(new_unit)
	current_player_units.append(new_unit)
	
	tile_manager.get_tile_from_coordinates(1, 1).take_unit(new_unit)
	new_unit.current_tile = tile_manager.get_tile_from_coordinates(1, 1)
	new_unit.current_projection = tile_manager.get_tile_from_coordinates(1, 1)
	new_unit.tile_change_requested.connect(func(x_coord, y_coord): 
		var tile = tile_manager.get_tile_from_coordinates(x_coord, y_coord)
		print(player_select_string)
		if tile:
			new_unit.get_node("ExplorationSprite").global_position = tile.position
			new_unit.current_exploration = tile
	)
	
	new_unit.request_step.connect(func(tile : Tile, action_name : String): 
		move_requested.emit(new_unit, tile, action_name)
		new_unit.current_projection = tile
	)
	
	return new_unit
	
