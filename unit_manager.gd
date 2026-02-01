class_name UnitManager extends Node2D

@export var tile_manager : TileManager

const UNIT_PATH = preload("res://unit.tscn")
const NPC_PATH = preload("res://npc.tscn")
var current_player_units : Array = []
var current_npcs : Array = []

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
		if tile:
			new_unit.get_node("ExplorationSprite").global_position = tile.position
			new_unit.current_exploration = tile
	)
	
	new_unit.request_step.connect(func(tile : Tile, action_name : String): 
		move_requested.emit(new_unit, tile, action_name)
		new_unit.current_projection = tile
	)
	
	return new_unit


func create_npc():
	var new_unit = NPC_PATH.instantiate()
	add_child(new_unit)
	current_npcs.append(new_unit)
	
	var tile = tile_manager.get_tile_from_coordinates(1, 1)
	new_unit.current_tile = tile
	tile.take_npc(new_unit)
	new_unit.position = tile.position
	
	return new_unit


func move_npc(npc : Npc):
	var adjacent_tiles = tile_manager.get_adjacent_tiles(npc.current_tile)
	var random_tile_index = randi_range(0, (adjacent_tiles.size() - 1))
	var random_tile = adjacent_tiles[random_tile_index]
	random_tile.take_npc(npc)
	var tween = get_tree().create_tween()
	tween.tween_property(npc, "position", random_tile.position, 1.0)


func move_all_npcs():
	for npc in current_npcs:
		move_npc(npc)
