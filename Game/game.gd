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
var found_player_controlled: bool = false
var energised_npcs: Array[Entity] = []

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	Engine.max_fps = 60
	player = Entity.new(Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	
	rng.randomize()
	map.generate(player, rng)
	map.update_fov(player.grid_position)
	
#REWRITE SYSTEM TO USE AN ACTION QUEUE AND AN ENERGY QUEUE

func _physics_process(_delta: float) -> void:
	if event_queue.is_empty():
		if not current_entity:
			var entities := map.entities.get_children()
			while not current_entity and energised_npcs.is_empty() and not entities.is_empty():
				energy_pass(entities)
				
		for entity in energised_npcs:
			event_queue.append(npc_action(entity))
		energised_npcs.clear()

		if current_entity:
			if player_action(current_entity):
				event_queue.append(player_action(current_entity))
				found_player_controlled = false
				current_entity = null
	else:
		var event: Event
		while not event_queue.is_empty():
			event = event_queue.pop_front()
			perform_action(event.action, event.target)
	

func energy_pass(entities: Array[Node]):
	for entity in entities:
		if Grid.a_within_b(player.grid_position, entity.grid_position, 15):
			entity.energy += entity.speed
			if entity.energy >= required_energy and not found_player_controlled:
				entity.energy = 0
				current_entity = entity
				if current_entity.is_player_controlled:
					found_player_controlled = true
				else:
					energised_npcs.append(current_entity)	
	if not found_player_controlled:
		current_entity = null	
					

func perform_action(action: Action, entity: Entity):
	if action:
		var previous_position := entity.grid_position
		action.perform(self, entity)
		if entity.grid_position != previous_position:
			map.update_fov(player.grid_position) #Does not handle multiple fields of view
		entity.energy = 0
		return true
	return false
				
func player_action(entity: Entity) -> Event:
	var action: Action = event_handler.get_action()
	if action:
		return Event.new(action, entity)
	return null

func npc_action(entity: Entity) -> Event:
	var action: Action = behaviour.get_action()
	if action:
		return Event.new(action, entity)
	return null
	
	
func get_map_data() -> MapData:
	return map.map_data
