class_name Npc extends CharacterBody2D

var current_tile : Tile = null
var is_npc : bool = true


func _ready() -> void:
	add_to_group("Units")


func dance_to_tile(tile : Tile):
	var tween = get_tree().create_tween()
	var empty_quadrant_index = tile.get_random_empty_quadrant_index()
	var old_tile = current_tile
	
	old_tile.release_npc_from_quadrant(self)
	current_tile = tile
	
	if empty_quadrant_index != null:
		var target_quadrant_node = tile.get_quadrant_from_index(empty_quadrant_index)
		tile.take_npc_to_quadrant(self, empty_quadrant_index)
		tween.tween_property(self, "position", target_quadrant_node.global_position, 1.0)
	else:
		tween.tween_property(self, "position", tile.global_position, 1.0)
