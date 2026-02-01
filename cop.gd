class_name Cop extends CharacterBody2D

var current_tile : Tile = null
var current_projection : Tile = null
var current_exploration : Tile = null
var food_amount : int = 0
var is_npc : bool = false
var steps_queued : int = 0
var is_revealed : bool = false

signal request_step(target_tile : Tile, action_name : String)
signal tile_change_requested(target_coordinate_x : int, target_coordinate_y : int)
signal action_confirmed(action_name : String)
signal landing_decided(decision : bool)
signal starting_surveillance
signal unit_turn_started
signal unit_turn_concluded
signal starting_player_targeting
signal awaiting_confirmation
signal awaiting_action

func _ready() -> void:
	add_to_group("Units")
