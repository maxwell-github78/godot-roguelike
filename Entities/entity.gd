class_name Entity
extends Sprite2D

var _definition: EntityDefinition
var speed: int 
var is_player_controlled: bool 
var energy: int = 0

var team: String 
var enemy_teams: Array[String] 

var tweens: Array[Tween] = []
var current_tween: Tween
const max_number_tweens: int = 3

@export var movement_animation_time: float = 0.1

var grid_position: Vector2i:
	set(value):
		grid_position = value
		#var movement_tween := create_tween()
		#movement_tween.tween_property(self, "position", Vector2(Grid.grid_to_world(grid_position)), movement_animation_time)

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
	position = Grid.grid_to_world(grid_position)
	set_entity_type(entity_definition)
	

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		if get_parent().has_signal("new_entity"):
			get_parent().emit_signal("new_entity", self)
			
func add_tween(tween: Tween):
	tweens.append(tween)
	tween.pause()
	tween.finished.connect(_tween_finished)
	if tweens.size() == 1 and not current_tween:
		current_tween = tweens.pop_front()
		current_tween.play()
	

		


func _tween_finished():
	current_tween = tweens.pop_front()
	if current_tween:
		current_tween.play()
		return
	position = Grid.grid_to_world(grid_position)
	
	
func move(move_offset: Vector2i) -> void:
	grid_position += move_offset
	
	
func is_blocking_movement() -> bool:
	return _definition.is_blocking_movement

func get_entity_name() -> String:
	return _definition.name

	
