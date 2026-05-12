class_name Behaviour
extends Node

@onready var game: Game = $".."
@onready var rng = game.rng

func get_action() -> Action:
	return confused()
	
	

func confused() -> Action:
	var direction = Grid.int_to_direction_eightfold(rng.randi_range(0, 7))
	return BumpAction.new(direction.x, direction.y)
