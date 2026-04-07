class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 80
@export var map_height: int = 80
@export_category("Room Dimensions")
@export var rectangle_minimum: int = 5
@export var rectangle_maximum: int = 10
@export var cave_minimum: int = 10
@export var cave_maximum: int = 40
@export var corridor_minimum: int = 4
@export var corridor_maximum: int = 8



var dungeon_rect := Rect2i(0, 0, map_width, map_height)

var _rng := RandomNumberGenerator.new()
var marks: Array[Mark]
var feature_bounds: Array[Vector2i]

var feature_weights := {
	"rectangular": [0, 49],
	"cave": [50, 99]
}
var feature_create_function := {
	"rectangular": _random_room_rectangle,
	"cave": _random_room_cave,
}



func _ready() -> void:
	_rng.seed = 487392543
	_rng.randomize()


func generate_dungeon() -> MapData:
	var dungeon := MapData.new(map_width, map_height)
	var walls: Array[TileDefinition] = [
		dungeon.tile_types.wall_blue,
		dungeon.tile_types.wall_red,
		]
	var start := Mark.new()
	start.position = Vector2i(map_width / 2, map_height / 2)
	var start_room:= _random_room_rectangle(start)
	marks += start_room.marks
	_carve_room(dungeon, start_room)
	var features: int = 0
	var attempts: int = 0
	var feature_type: String = "room"
	while len(feature_bounds) < 0.55 * map_width * map_height and len(marks) > 0 and attempts < 5000:
	#while features < 2:
		attempts += 1
		var feature_number := _rng.randi_range(0, 99)
		for key in feature_weights.keys():
			if feature_number >= feature_weights[key][0] and feature_number <= feature_weights[key][1]:
				feature_type = key
		var index := _rng.randi_range(0, max(0, len(marks) - 1))
		var candidate_mark: Mark = marks[index]
		var candidate_room = feature_create_function[feature_type].call(candidate_mark)
		for mark in candidate_room.marks:
			if mark.direction + candidate_mark.direction == Vector2i(0, 0):
				var amount = candidate_room.rect.position - mark.position 
				candidate_room.rect.position += amount
				candidate_room.shift(amount)
				candidate_room.init_marks()
				var result = _carve_room(dungeon, candidate_room)
				if result:
					marks += candidate_room.marks
					marks.remove_at(index)
					candidate_room.walls()
					var wall_index := _rng.randi_range(0, max(0, len(walls) - 1))
					var definition := walls[wall_index]
					_carve_room_walls(dungeon, candidate_room, definition)
					_carve_tile(dungeon, candidate_mark.position.x, candidate_mark.position.y, dungeon.tile_types.debug)
					features += 1
					#for debug in candidate_room.marks:
						#_carve_tile(dungeon, debug.position.x, debug.position.y, dungeon.tile_types.debug)

					
					
	print(len(feature_bounds))
	print(map_width * map_height)
	print(attempts)
	return dungeon
	
func _carve_tile(dungeon: MapData, x: int, y: int, type: TileDefinition) -> bool:
		var tile_position = Vector2i(x, y)
		var tile: Tile = dungeon.get_tile(tile_position)
		if not tile:
			return false
		tile.set_tile_type(type)
		return true
		
func _random_room_rectangle(mark: Mark) -> Rectangular:
	var position := mark.position
	var rect := Rect2i(position.x, position.y, 
	_rng.randi_range(rectangle_minimum, rectangle_maximum),
	 _rng.randi_range(rectangle_minimum, rectangle_maximum))
	var out = Rectangular.new(_rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out

func _random_room_cave(mark: Mark) -> Cave:
	var position := mark.position
	var rect := (Rect2i(position.x, position.y, 
	_rng.randi_range(cave_minimum, cave_maximum),
	_rng.randi_range(cave_minimum, cave_maximum)))
	var out = Cave.new(_rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out
	
		
func _carve_room(dungeon: MapData, room: Room) -> bool:
	var working := room.rect.grow(-1)
	if not _rect_inside_rect(room.rect, dungeon_rect):
		return false
	
	for vector in room.tiles_to_carve:
		if vector in feature_bounds:
			return false
	
	for vector in room.tiles_to_carve:
		feature_bounds.append(vector)
		_carve_tile(dungeon, vector.x, vector.y, dungeon.tile_types.floor)
			
	return true

func _carve_room_walls(dungeon: MapData, room: Room, type: TileDefinition):
	for vector in room.tiles_to_wall:
		if dungeon.get_tile(vector).get_tile_type() != dungeon.tile_types.floor:
			_carve_tile(dungeon, vector.x, vector.y, type)
	

	
func _rect_inside_rect(rect_small: Rect2i, rect_big: Rect2i) -> bool:
	return (
		rect_big.has_point(rect_small.position) and 
		rect_big.has_point(rect_small.end) and
		rect_big.has_point(Vector2i(rect_small.position.x, rect_small.end.y)) and
		rect_big.has_point(Vector2i(rect_small.end.x, rect_small.position.y))
	)

	
	
	
	
