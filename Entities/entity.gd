class_name Entity
extends Sprite2D

var _definition: EntityDefinition
var speed: int 
var is_player_controlled: bool 
var energy: int = 0

var team: String 
var enemy_teams: Array[String] 

@export var movement_animation_time: float = 0.1

var grid_position: Vector2i:
	set(value):
		grid_position = value
		var movement_tween := create_tween()
		movement_tween.tween_property(self, "position", Vector2(Grid.grid_to_world(grid_position)), movement_animation_time)

func set_entity_type(entity_definition: EntityDefinition) -> void:
	_definition = entity_definition
	texture = entity_definition.texture
	speed = _definition.speed
	is_player_controlled = _definition.is_player_controlled
	team = _definition.team
	enemy_teams = _definition.enemy_teams
	
func _init(start_position: Vector2i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	set_entity_type(entity_definition)
	
func move(move_offset: Vector2i) -> void:
	grid_position += move_offset
	
	
func is_blocking_movement() -> bool:
	return _definition.is_blocking_movement

func get_entity_name() -> String:
	return _definition.name

	
