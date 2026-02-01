class_name Tile extends Area2D

@export var x_coordinate : int = 0
@export var y_coordinate : int = 0
@export var food_amount : int = 0

var current_units : Array = []

func _ready() -> void:
	add_to_group("Tiles")
	update_food_tally()


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
