class_name Game
extends Node2D

const player_definition: EntityDefinition = preload("res://assets/definitions/actors/entity_definition_player.tres")

@onready var player: Entity
@onready var event_handler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map

func _ready() -> void:
	Engine.max_fps = 60
	player = Entity.new(Vector2i(42, 42), player_definition)
	var camera: Camera2D = $Camera2D
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)

func _physics_process(delta: float) -> void:
	var action: Action = event_handler.get_action()
	if action:
		action.perform(self, player)
	
func get_map_data() -> MapData:
	return map.map_data
