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
	var distance_from_player_start: Vector2i
	var tile: Tile
	assert(n_monsters < dungeon.floor_grid_positions.size())
	var monster_count: int = 0
	while monster_count <= n_monsters:
		index = rng.randi_range(0, dungeon.floor_grid_positions.size() - 1)
		grid_position = dungeon.floor_grid_positions.pop_at(index)
		distance_from_player_start = grid_position - dungeon.player_start_position
		tile = dungeon.get_tile_xy(grid_position.x, grid_position.y)
		if distance_from_player_start.x**2 + distance_from_player_start.y**2 < 5**2 or not tile.is_walkable():
			continue
		feature_number = rng.randi_range(0, 99)
		for key in feature_weights.keys():
			if feature_number >= feature_weights[key][0] and feature_number <= feature_weights[key][1]:
				feature_type = actor_types[key]
				
		entity = Entity.new(grid_position, feature_type)
		dungeon.entities.append(entity)
		monster_count += 1
	
