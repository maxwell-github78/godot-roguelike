class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 160
@export var map_height: int = 160

@onready var player_start_position: Vector2i = Vector2i( map_width / 2 + 3, map_height / 2 + 3)

@onready var tile_generator: TileGenerator = $TileGenerator
@onready var entity_generator: EntityGenerator = $EntityGenerator
	
func generate_dungeon(player: Entity, rng: RandomNumberGenerator) -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	
	player.grid_position = player_start_position
	player.position = Grid.grid_to_world(player.grid_position) #Prevent tween animation
	dungeon.entities.append(player)
	
	tile_generator.generate(dungeon, rng)
	entity_generator.generate(dungeon, rng)
	dungeon.setup_pathfinding()
	return dungeon
	
