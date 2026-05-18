class_name Entity
extends Sprite2D

var _definition: EntityDefinition
var speed: int 
var is_player_controlled: bool 
var energy: int = 0
var blur: bool = false

var team: String 
var enemy_teams: Array[String] 
var shade := RandomNumberGenerator.new().randf()

var animations: Array[MovementAnimation] = []
var current_animation: MovementAnimation
const max_number_tweens: int = 3
var game: Game
var map_data: MapData

enum AIType {NONE, MELEE}
var ai_component: BaseAIComponent
var health_component: HealthComponent

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
	
	match entity_definition.ai_type:
		AIType.MELEE:
			ai_component = MeleeEnemyAIComponent.new()
			add_child(ai_component)
	
	if entity_definition.max_hp != 0:
		health_component = HealthComponent.new(entity_definition)
		add_child(health_component)
		health_component.died.connect(remove)
	
func _init(in_game: Game, start_position: Vector2i, entity_definition: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	position = Grid.grid_to_world(grid_position)
	game = in_game
	set_entity_type(entity_definition)
	

func _notification(what):
	if what == NOTIFICATION_PARENTED:
		if get_parent().has_signal("new_entity"):
			get_parent().emit_signal("new_entity", self)

			
func add_animation(animation: MovementAnimation):
	var tween = animation.tween
	animations.append(animation)
	tween.pause()
	tween.finished.connect(_tween_finished)
	
	
	detect_afterimage()
		
	if animations.size() == 1 and not current_animation:
		current_animation = animations.pop_front()
		current_animation.play()
		
func detect_afterimage() -> void:
	if animations.size() + 1 >= max_number_tweens or blur:
		if current_animation:
			animations.push_front(current_animation)
			current_animation.end()
		for killed_animation in animations:
			if killed_animation.make_afterimage:
				killed_animation.draw_afterimage()
			killed_animation.end()
		
		animations.clear()
		current_animation = null
		
		blur = true
	
func _tween_finished() -> void:
	if animations.is_empty():
		current_animation.game.map.update_fov(current_animation.game.player.grid_position)
		visible = current_animation.tiles.get_tile(grid_position).is_in_view
	current_animation = animations.pop_front()
	if current_animation:
		detect_afterimage()
		current_animation.play()
		return
	position = Grid.grid_to_world(grid_position)
	
	
func move(move_offset: Vector2i) -> void:
	game.get_map_data().unregister_blocking_entity(self)
	grid_position += move_offset
	game.get_map_data().register_blocking_entity(self)
	if blur:
		position = Grid.grid_to_world(grid_position)
		visible = game.get_map_data().get_tile(grid_position).is_in_view

func remove():
	var parent := get_parent()
	if parent:
		parent.remove_child(self)
		parent.removed_entity.emit(self)
	else:
		print("failed to kill self: ", get_entity_name())
	
		
	
	
func is_blocking_movement() -> bool:
	if health_component:
		if health_component.hp == 0:
			return false
	return _definition.is_blocking_movement

func get_entity_name() -> String:
	return _definition.name
	
func get_entity_power() -> int:
	return _definition.power
	
func get_entity_texture() -> Texture2D:
	return texture

	
