class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/actors/player.tres")
@onready var camera: Camera2D = $Camera2D
@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var map: Map = $Map
@onready var behaviour: Behaviour = $Behaviour

var turn_queue: Array[Entity] = []
var action_queue: Array[Action] = []
const required_energy: int = 100
var current_entity: Entity 
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	Engine.max_fps = 60
	player = Entity.new(Vector2i.ZERO, player_definition)
	remove_child(camera)
	player.add_child(camera)
	
	rng.randomize()
	map.generate(player, rng)
	map.update_fov(player.grid_position)
	
#THIS NEEDS A REWRITE TO USE THE QUEUE SYSTEM FOR NPC ENTITIES
#THEY CANNOT USE A FRAME FOR THEMSELVES
#INSTEAD OF BECOMING CURRENT_ENTITY THEY MUST ADD THEIR ACTION TO THE QUEUE AND PASS IT ON
#AT THE END OF THE LOOP, EVEN IF A PLAYER-CONTROLLED ENTITY IS FOUND, THE QUEUE CAN BE WORKED THROUGH
#ALSO, IF NO ACTOR IS READY, THE FRAME IS WASTED. MOVE THE ENERGY LOOP TO A FUNCTION TO BE CALLED AGAIN
#IN THE EVENT NOTHING IS FOUND
func _physics_process(_delta: float) -> void:
	if not current_entity:
		for entity in map.entities.get_children():
			if Grid.a_within_b(player.grid_position, entity.grid_position, 15):
				entity.energy += entity.speed
				if entity.energy >= required_energy:
					entity.energy = 0
					current_entity = entity
					break
	if current_entity:
		#print(current_entity.get_entity_name())
		if current_entity.is_player_controlled:
			if player_action(current_entity):
				current_entity = null
		else:
			if npc_action(current_entity):
				current_entity = null
						
					

func perform_action(action: Action, entity: Entity):
	if action:
		var previous_position := entity.grid_position
		action.perform(self, entity)
		if entity.grid_position != previous_position:
			map.update_fov(player.grid_position) #Does not handle multiple fields of view
		return true
	return false
				
func player_action(entity: Entity) -> bool:
	var action: Action = event_handler.get_action()
	return perform_action(action, entity)

func npc_action(entity: Entity) -> bool:
	var action: Action = behaviour.get_action()
	return perform_action(action, entity)
	
	
func get_map_data() -> MapData:
	return map.map_data
