class_name TileManager extends Node2D

const TILE_PATH = preload("res://tile.tscn")
var tiles : Array = []

var map_size_x : int = 0
var map_size_y : int = 0

func create_map(size_x : int, size_y : int):
	for current_x in range(size_x):
		for current_y in range(size_y):
			var new_tile = TILE_PATH.instantiate()
			add_child(new_tile)
			new_tile.x_coordinate = current_x
			new_tile.y_coordinate = current_y
			var pos_x = (256 * current_x) + 128
			var pos_y = (256 * current_y) + 128
			
			new_tile.position = Vector2(pos_x, pos_y)
			tiles.append(new_tile)
			
			new_tile.add_food(5)
	
	map_size_x = size_x
	map_size_y = size_y


func get_tile_from_coordinates(x_coordinate : int, y_coordinate : int):
	for tile in tiles:
		if tile.x_coordinate == x_coordinate and tile.y_coordinate == y_coordinate:
			return tile
