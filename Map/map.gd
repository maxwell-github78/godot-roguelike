class_name Map
extends Node2D

@onready var dungeon_generator: DungeonGenerator = $DungeonGenerator

var map_data: MapData

func _ready() -> void:
	var before_time := Time.get_unix_time_from_system()
	map_data = dungeon_generator.generate_dungeon()
	var after_time: = Time.get_unix_time_from_system()
	print(after_time - before_time, " seconds to generate the dungeon")
	_place_tiles()



func _place_tiles() -> void:
	for tile in map_data.tiles:
		add_child(tile)
