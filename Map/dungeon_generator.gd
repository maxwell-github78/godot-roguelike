class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 160
@export var map_height: int = 160

@onready var player_start_position: Vector2i = Vector2i( map_width / 2 + 2, map_height / 2 + 2)

var _rng := RandomNumberGenerator.new()
@onready var tile_generator: TileGenerator = $TileGenerator
@onready var entity_generator: EntityGenerator = $EntityGenerator

func _ready() -> void:
	#_rng.seed = 4738259
	_rng.randomize()
	
func generate_dungeon(player: Entity) -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	
	player.grid_position = player_start_position
	dungeon.entities.append(player)
	
	tile_generator.generate(dungeon, _rng)
	entity_generator.generate(dungeon, _rng)
	return dungeon
	
