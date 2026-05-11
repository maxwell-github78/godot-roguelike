class_name EntityGenerator
extends Node

@export var n_monsters: int = 100
@export var path_string: String = "res://assets/definitions/actors/"

var actor_types: Dictionary
const feature_weights := {
	"guard": [0,49],
	"celestial": [50, 99],
}

func _ready() -> void:
	actor_types = Files.read_definitions(path_string)

func generate(dungeon: MapData, rng: RandomNumberGenerator):
	var grid_position: Vector2i
	var index: int
	var feature_number: int
	var feature_type: EntityDefinition
	var entity: Entity
	assert(n_monsters < dungeon.floor_grid_positions.size())
	for i in range(n_monsters):
		index = rng.randi_range(0, dungeon.floor_grid_positions.size() - 1)
		grid_position = dungeon.floor_grid_positions.pop_at(index)
		feature_number = rng.randi_range(0, 99)
		for key in feature_weights.keys():
			if feature_number >= feature_weights[key][0] and feature_number <= feature_weights[key][1]:
				feature_type = actor_types[key]
				
		entity = Entity.new(grid_position, feature_type)
		dungeon.entities.append(entity)
	
