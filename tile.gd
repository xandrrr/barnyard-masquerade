class_name Tile extends Area2D

@export var x_coordinate : int = 0
@export var y_coordinate : int = 0
@export var food_amount : int = 0

var current_units : Array = []
var quadrant_map : Dictionary = {}

var quadrant_occupants : Dictionary = {
	1 : null,
	2 : null,
	3 : null,
	4 : null
}

func _ready() -> void:
	add_to_group("Tiles")
	update_food_tally()
	
	quadrant_map = {
	1 : $Quadrants/Quadrant1,
	2 : $Quadrants/Quadrant2,
	3 : $Quadrants/Quadrant3,
	4 : $Quadrants/Quadrant4
}


func take_unit(unit : Unit):
	unit.position = self.position
	unit.current_exploration = self


func take_cop(cop : Cop):
	cop.position = self.position
	cop.current_exploration = self


func take_npc(npc : Npc):
	npc.current_tile = self


func distribute_food(unit : Unit, amount : int):
	var food_taken = min(food_amount, amount)
	food_amount -= food_taken
	unit.food_amount += food_taken


func update_food_tally():
	$TileControl/FoodAmountLabel.text = "Food: " + str(food_amount)


func add_food(amount : int):
	food_amount += amount


func remove_food(amount : int):
	var food_removed = min(food_amount, amount)
	food_amount -= food_removed


func get_empty_quadrant_indexes():
	var empty_quadrant_indexes : Array = []
	
	for quadrant in quadrant_occupants.keys():
		if quadrant_occupants[quadrant] == null:
			empty_quadrant_indexes.append(quadrant)
	
	return empty_quadrant_indexes


func get_random_empty_quadrant_index():
	var empty_quadrant_indexes : Array = get_empty_quadrant_indexes()
	if !empty_quadrant_indexes.is_empty():
		return empty_quadrant_indexes[randi_range(0, (empty_quadrant_indexes.size() - 1))]
	else:
		return null


func take_unit_to_quadrant(unit : Unit, quadrant : int):
	quadrant_occupants[quadrant] = unit


func take_npc_to_quadrant(unit : Npc, quadrant : int):
	quadrant_occupants[quadrant] = unit


func release_unit_from_quadrant(unit : Unit):
	for quadrant in quadrant_occupants.keys():
		if quadrant_occupants[quadrant] == unit:
			quadrant_occupants[quadrant] = null
			return


func release_npc_from_quadrant(unit : Npc):
	for quadrant in quadrant_occupants.keys():
		if quadrant_occupants[quadrant] == unit:
			quadrant_occupants[quadrant] = null
			return


func get_quadrant_from_index(index : int):
	return quadrant_map[index]
