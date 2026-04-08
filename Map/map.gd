class_name Map
extends Node2D

@export var fov_radius: int = 8
@onready var field_of_view: FieldOfView = $FieldOfView

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator


var map_data: MapData

func _ready() -> void:
	var before_time := Time.get_unix_time_from_system()
	map_data = dungeon_generator.generate_dungeon()
	var after_time: = Time.get_unix_time_from_system()
	print(after_time - before_time, " seconds to generate the dungeon")
	_place_tiles()

func update_fov(player_position: Vector2i) -> void:
	field_of_view.update_fov(map_data, player_position, fov_radius)



func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)

func _on_debug_light_debug_changed(value: bool) -> void:
	if value:
		for tile in map_data.tiles:
			tile.is_explored = true
