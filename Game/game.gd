class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/actors/player.tres")
@onready var camera: Camera2D = $Camera2D
@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var map: Map = $Map
@onready var behaviour: Behaviour = $Behaviour

var turn_queue: Array[Entity] = []
var event_queue: Array[Event] = []
const required_energy: int = 100
var current_entity: Entity 
var player_controlled_entity: Entity
var energised_npcs: Array[Entity] = []
var current_index: int = 0
var entities: Array[Entity]
var interruptions: int
var moves: Dictionary[Entity, Array] = {}

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	Engine.max_fps = 60
	player = Entity.new(Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	
	rng.randomize()
	map.generate(player, rng)
	map.update_fov(player.grid_position)

func _process(_delta: float) -> void:
	#print(interruptions)
	if interruptions > 0:
		return
	if event_queue.is_empty() and not player_controlled_entity:
		while not player_controlled_entity and not entities.is_empty():
			current_entity = entities.pop_front()
			entities.append(current_entity)
			if Grid.a_within_b(current_entity.grid_position, player.grid_position, 10):
				current_entity.energy += current_entity.speed
			if current_entity.energy >= 100:
				current_entity.energy -= 100
				if current_entity.is_player_controlled:
					player_controlled_entity = current_entity
					break
				else:
					energised_npcs.append(current_entity)
			
		for entity in energised_npcs:
			event_queue.append(_npc_action(entity))
		energised_npcs.clear()

	if player_controlled_entity:
		var player_event := _player_action(player_controlled_entity)
		if player_event:
			event_queue.append(player_event)
			player_controlled_entity = null

	var event: Event
	while not event_queue.is_empty():
		if interruptions > 0:
			return
		event = event_queue.pop_front()
		_perform_action(event.action, event.target)
	
					
func _perform_action(action: Action, entity: Entity):
	if action:
		var previous_position := entity.grid_position
		action.perform(self, entity)
		if entity.grid_position != previous_position:
			if entity.is_player_controlled:
				map.update_fov(player.grid_position) #Does not handle multiple fields of view
			else:
				map.update_entity_visibility()
		entity.energy = 0
		return true
	return false
				
func _player_action(entity: Entity) -> Event:
	var action: Action = event_handler.get_action()
	if action:
		return Event.new(action, entity)
	return null

func _npc_action(entity: Entity) -> Event:
	var action: Action = behaviour.get_action()
	if action:
		return Event.new(action, entity)
	return null
	
	
func get_map_data() -> MapData:
	return map.map_data

func _on_entities_new_entity(entity: Entity) -> void:
	entities.append(entity)
	
func _on_entity_removed(entity: Entity):
	var index = entities.rfind(entity)
	entities.remove_at(index)
