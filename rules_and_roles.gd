extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rule_card_one_pressed() -> void:
	$ruleCardOne.visible = false
	$rulesLabel.visible = false
	$ruleCardTwo.visible = true
	$turnsLabel.visible = true
	
	#pass # Replace with function body.


func _on_rule_card_two_pressed() -> void:
	$ruleCardTwo.visible = false
	$turnsLabel.visible = false
	$ruleCardOne.visible = true
	$rulesLabel.visible = true
	
	#pass # Replace with function body.


func _on_roles_card_one_pressed() -> void:
	$rolesCardOne.visible = false
	$rolesLabel.visible = false
	$rolesCardTwo.visible = true
	$moreRolesLabel.visible = true
	pass # Replace with function body.


func _on_roles_card_two_pressed() -> void:
	$rolesCardTwo.visible = false
	$moreRolesLabel.visible = false
	$rolesCardOne.visible = true
	$rolesLabel.visible = true
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://starter_menu.tscn")
	pass # Replace with function body.
