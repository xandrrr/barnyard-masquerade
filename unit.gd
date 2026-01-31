class_name Unit extends CharacterBody2D

var current_tile : Tile = null
var current_projection : Tile = null
var current_exploration : Tile = null
var food_amount : int = 0
var is_npc : bool = false

signal request_step(target_tile : Tile, action_name : String)
signal tile_change_requested(target_coordinate_x : int, target_coordinate_y : int)

func _ready() -> void:
	add_to_group("Units")
	
	var scene_tree = get_tree()
	scene_tree.get_first_node_in_group("Tiles").take_unit(self)
	update_food_tally()


func update_food_tally():
	$UnitControl/FoodAmountLabel.text = "Food: " + str(food_amount)
