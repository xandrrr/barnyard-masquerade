class_name Npc extends CharacterBody2D

var current_tile : Tile = null
var is_npc : bool = true


func _ready() -> void:
	add_to_group("Units")
