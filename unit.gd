class_name Unit extends CharacterBody2D

var current_tile : Tile = null
var current_projection : Tile = null
var current_exploration : Tile = null
var food_amount : int = 0
var is_npc : bool = false
var steps_queued : int = 0
var is_revealed : bool = false

signal request_step(target_tile : Tile, action_name : String)
signal tile_change_requested(target_coordinate_x : int, target_coordinate_y : int)
signal starting_dance
signal unit_turn_started
signal unit_turn_concluded

func _ready() -> void:
	add_to_group("Units")
	
	update_food_tally()


func update_food_tally():
	$UnitControl/FoodAmountLabel.text = "Food: " + str(food_amount)


func cast_projection(tile : Tile):
	$BodyProjectionSprite.position = tile.position


func dance_to_tile(tile : Tile):
	var tween = get_tree().create_tween()
	var empty_quadrant_index = tile.get_random_empty_quadrant_index()
	var old_tile = current_tile
	
	old_tile.release_unit_from_quadrant(self)
	current_tile = tile
	
	if empty_quadrant_index != null:
		var target_quadrant_node = tile.get_quadrant_from_index(empty_quadrant_index)
		tile.take_unit_to_quadrant(self, empty_quadrant_index)
		tween.tween_property(self, "position", target_quadrant_node.global_position, 1.0)
	else:
		tween.tween_property(self, "position", tile.global_position, 1.0)
