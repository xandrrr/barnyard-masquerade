class_name State extends Node

signal finished(next_state: String, data: Dictionary)

func handle_input(_event: InputEvent):
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func enter(previous_state_path: String, data := {}) -> void:
	pass


func exit() -> void:
	pass
