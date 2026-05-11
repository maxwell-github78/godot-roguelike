class_name TileGenerator
extends Node

@export_category("Room Dimensions")
@export var rectangle_minimum: int = 5
@export var rectangle_maximum: int = 10
@export var cave_minimum: int = 10
@export var cave_maximum: int = 40
@export var round_minimum: int = 6
@export var round_maximum: int = 12
@export var corridor_length_minimum: int = 8
@export var corridor_length_maximum: int = 20
@export var corridor_width_minimum: int = 3
@export var corridor_width_maximum: int = 3

var marks: Array[Mark]
var feature_bounds: Array[Vector2i]
var fixed: Array[Vector2i]

var map_width: int
var map_height: int
var dungeon_rect: Rect2i
var rng: RandomNumberGenerator

const feature_weights := {
	"rectangular": [0,49],
	"cave": [50, 79],
	"round": [80, 99],
	#"corridor": [30, 59],
}
var feature_create_function := {
	"rectangular": _random_room_rectangle,
	"cave": _random_room_cave,
	"round": _random_room_round,
	"corridor": _random_room_corridor,
}


func generate(dungeon: MapData, in_rng: RandomNumberGenerator):
	map_width = dungeon.width
	map_height = dungeon.height
	rng = in_rng
	dungeon_rect = Rect2i(0, 0, map_width, map_height)
	var walls: Array[TileDefinition] = [
		dungeon.tile_types.wall_blue,
		dungeon.tile_types.wall_red,
		]
	var start := Mark.new()
	start.position = Vector2i(map_width / 2, map_height / 2)
	var start_room:= _random_room_round(start)
	start_room.walls()
	#for debug in start_room.marks:
		#_carve_tile(dungeon, debug.position.x, debug.position.y, dungeon.tile_types.debug)
	marks += start_room.marks
	_carve_room(dungeon, start_room)
	_carve_room_walls(dungeon, start_room, dungeon.tile_types.wall_blue)
	
	var start_features: Array[Vector2i] = feature_bounds.duplicate_deep()
	
	var _features: int = 0
	var attempts: int = 0
	var feature_type: String = "room"
	while len(feature_bounds) < 0.15 * map_width * map_height and len(marks) > 0 and attempts < 5000:
	#while _features < 1 and attempts < 5000:
		attempts += 1
		var feature_number := rng.randi_range(0, 99)
		for key in feature_weights.keys():
			if feature_number >= feature_weights[key][0] and feature_number <= feature_weights[key][1]:
				feature_type = key
		var index := rng.randi_range(0, max(0, len(marks) - 1))
		var candidate_mark: Mark = marks[index]
		var candidate_room = feature_create_function[feature_type].call(candidate_mark)
		for mark in candidate_room.marks:
			if mark.direction + candidate_mark.direction == Vector2i(0, 0):
				var new_spot: Vector2i = mark.position #+ mark.direction
				var amount: Vector2i = candidate_room.rect.position - new_spot
				candidate_room.rect.position += amount
				new_spot += amount #- mark.direction
				candidate_room.shift(amount)
				candidate_room.init_marks()
				var result = _carve_room(dungeon, candidate_room)
				if result:
					marks += candidate_room.marks
					marks.remove_at(index)
					candidate_room.walls()
					var wall_index := rng.randi_range(0, max(0, len(walls) - 1))
					var definition := walls[wall_index]
					_carve_room_walls(dungeon, candidate_room, definition)
					var portal: TileDefinition 
					if rng.randf() > 0.7:
						portal = dungeon.tile_types.door
					else:
						portal = dungeon.tile_types.floor
					_carve_tile(dungeon, candidate_mark.position.x, candidate_mark.position.y, portal)
	
					#_carve_tile(dungeon, new_spot.x, new_spot.y, dungeon.tile_types.floor)
					fixed.append(new_spot)
					var front: Vector2i = new_spot + 1 * mark.direction
					var back: Vector2i = new_spot - 1 * mark.direction
					fixed.append(front)
					fixed.append(back)
					_carve_tile(dungeon, front.x, front.y, dungeon.tile_types.floor)
					_carve_tile(dungeon, back.x, back.y, dungeon.tile_types.floor)
					_features += 1
					#for debug in candidate_room.marks:
						#_carve_tile(dungeon, debug.position.x, debug.position.y, dungeon.tile_types.debug)
	
	check_discoverability(dungeon)
	autotile(dungeon)		
	
	dungeon.floor_grid_positions = feature_bounds 
					
	print("Tiles covered: ", len(feature_bounds))
	print("Map area: ", map_width * map_height)
	print("Attemps to place features: ", attempts)
	
func _carve_tile(dungeon: MapData, x: int, y: int, type: TileDefinition) -> bool:
		var tile_position = Vector2i(x, y)
		if tile_position in fixed:
			return false
		var tile: Tile = dungeon.get_tile(tile_position)
		if not tile:
			return false
		tile.set_tile_type(type)
		return true
		
func _random_room_rectangle(mark: Mark) -> Rectangular:
	var position := mark.position
	var rect := Rect2i(position.x, position.y, 
	rng.randi_range(rectangle_minimum, rectangle_maximum),
	 rng.randi_range(rectangle_minimum, rectangle_maximum))
	var out = Rectangular.new(rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out

func _random_room_cave(mark: Mark) -> Cave:
	var position := mark.position
	var rect := (Rect2i(position.x, position.y, 
	rng.randi_range(cave_minimum, cave_maximum),
	rng.randi_range(cave_minimum, cave_maximum)))
	var out = Cave.new(rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out

func _random_room_round(mark: Mark) -> Round:
	var position := mark.position
	var rect := Rect2i(position.x, position.y, 
	rng.randi_range(round_minimum, round_maximum),
	 rng.randi_range(round_minimum, round_maximum))
	var out = Round.new(rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out
	
func _random_room_corridor(mark: Mark):
	var position := mark.position
	var rect: Rect2i
	if rng.randi_range(0, 1) == 1:
		rect = Rect2i(position.x, position.y, 
		rng.randi_range(corridor_width_minimum, corridor_width_maximum),
		rng.randi_range(corridor_length_minimum, corridor_length_maximum))
	else:
		rect = Rect2i(position.x, position.y, 
		rng.randi_range(corridor_length_minimum, corridor_length_maximum),
		rng.randi_range(corridor_width_minimum, corridor_width_maximum))
	var out = Rectangular.new(rng)
	out.rect = rect
	out.dig()
	out.init_marks()
	return out
	
		
func _carve_room(dungeon: MapData, room: Room) -> bool:
	if not _rect_inside_rect(room.rect.grow(1), dungeon_rect):
		return false
	
	for vector in room.tiles_to_carve:
		if vector in feature_bounds:
			return false
	
	for vector in room.tiles_to_carve:
		feature_bounds.append(vector)
		_carve_tile(dungeon, vector.x, vector.y, dungeon.tile_types.floor)
			
	return true

func _carve_room_walls(dungeon: MapData, room: Room, type: TileDefinition):
	var ineditable: Array[TileDefinition] = [
		#dungeon.tile_types.floor, 
		dungeon.tile_types.debug,
		dungeon.tile_types.door
		]
	var current: TileDefinition
	for vector in room.tiles_to_wall:
		current = dungeon.get_tile(vector).get_tile_type()
		if not current in ineditable:
			_carve_tile(dungeon, vector.x, vector.y, type)
	

	
func _rect_inside_rect(rect_small: Rect2i, rect_big: Rect2i) -> bool:
	return (
		rect_big.has_point(rect_small.position) and 
		rect_big.has_point(rect_small.end) and
		rect_big.has_point(Vector2i(rect_small.position.x, rect_small.end.y)) and
		rect_big.has_point(Vector2i(rect_small.end.x, rect_small.position.y))
	)

func check_discoverability(dungeon: MapData):
	for tile in dungeon.tiles:
		var origin := Vector2i(Grid.world_to_grid(tile.position))
		tile.is_discoverable = discoverable(dungeon, origin)
		
func discoverable(dungeon: MapData, origin: Vector2i) -> bool:
		for x in range(-1, 2):
			for y in range(-1, 2):
				if x != 0 or y != 0:
					var candidate: Vector2i = origin + Vector2i(x, y)
					if dungeon_rect.has_point(candidate):
						var candidate_tile = dungeon.get_tile(candidate)
						if candidate_tile.is_walkable():
							return true
		return false

func autotile(dungeon: MapData):
	for tile in dungeon.tiles:
		if tile.has_side:
			var grid_position := Grid.world_to_grid(tile.position)
			if grid_position.y < map_height:
				var origin = Vector2i(grid_position)
				var under = dungeon.get_tile(origin + Vector2i(0, 1))
				if under and under.empty() and tile.is_discoverable:
					tile.side = true
					tile.set_autotiling()
	
	
	
