class_name Map
extends Node2D

@onready var tiles: Node2D = $Tiles
@onready var entities: Node2D = $Entities
@onready var animation_sprites: Node2D = $AnimationSprites
@export var fov_radius: int = 8
@onready var field_of_view: FieldOfView = $FieldOfView

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator


var map_data: MapData

func generate(player: Entity, rng: RandomNumberGenerator):
	var before_time := Time.get_unix_time_from_system()
	map_data = dungeon_generator.generate_dungeon(player, rng)
	var after_time: = Time.get_unix_time_from_system()
	print(after_time - before_time, " seconds to generate the dungeon")
	_place_tiles()
	_place_entities()
	

func update_fov(player_position: Vector2i) -> void:
	field_of_view.update_fov(map_data, player_position, 8)
	
	

func update_entity_visibility() -> void:
	for entity in map_data.entities:
		pass
		#entity.visible = map_data.get_tile(entity.grid_position).is_in_view

func _place_entities() -> void:
	for entity in map_data.entities:
		entities.add_child(entity)

func _place_tiles() -> void:
	for tile in map_data.tiles:
		tiles.add_child(tile)

func _on_debug_light_debug_changed(value: bool) -> void:
	if value:
		for tile in map_data.tiles:
			tile.is_explored = true
