class_name MapData
extends RefCounted

var tile_types: Dictionary = {}

var dir_path_string: String = "res://assets/definitions/tiles"
var dir := DirAccess.open(dir_path_string)

var width: int
var height: int
var tiles: Array[Tile]


func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	_read_tile_definitions()
	_setup_tiles()
	
func _read_tile_definitions():
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file_path_string = dir_path_string + "/" + file_name
			var key: String = file_name.replace(".tres", "")
			#print(key)
			tile_types[key] = load(file_path_string)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path to the tile definitions")

func _setup_tiles() -> void:
	tiles = []
	for y in height:
		for x in width:
			var tile_position := Vector2i(x, y)
			var tile := Tile.new(tile_position, tile_types.stone)
			tiles.append(tile)


func get_tile(grid_position: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_position)
	if tile_index == -1:
		return null
	return tiles[tile_index]
	
func get_tile_xy(x: int, y: int) -> Tile:
	var grid_position := Vector2i(x, y)
	return get_tile(grid_position)
	
func grid_to_index(grid_position: Vector2i) -> int:
	if not is_in_bounds(grid_position):
		return -1
	return grid_position.y * width + grid_position.x
	
func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)
