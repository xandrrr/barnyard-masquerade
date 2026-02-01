class_name Npc extends CharacterBody2D

var current_tile : Tile = null
var is_npc : bool = true
var is_revealed : bool = false
var is_eliminated : bool = false
var character_name : String

func _ready() -> void:
	add_to_group("Units")


func dance_to_tile(tile : Tile):
	var tween = get_tree().create_tween()
	var empty_quadrants = tile.get_empty_quadrant_indexes()
	#choose random index from above
	
	var old_tile = current_tile
	
	if !empty_quadrants.is_empty():
		var empty_quadrant_index = randi_range(0, (empty_quadrants.size() - 1))
		var target_index = empty_quadrants[empty_quadrant_index]
		var target_quadrant_node = tile.get_quadrant_from_index(target_index)
		tile.take_npc_to_quadrant(self, target_index)
		tween.tween_property(self, "position", target_quadrant_node.global_position, 1.0)
		old_tile.release_npc_from_quadrant(self)
		current_tile = tile
	else:
		pass
