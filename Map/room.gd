class_name Room
extends Object

var marks: Array[Mark]
var rect: Rect2i
var rng: RandomNumberGenerator
var tiles_to_carve : Array[Vector2i]
var tiles_to_wall: Array[Vector2i]

func _init(in_rng: RandomNumberGenerator):
	rng = in_rng
	
func shift(amount: Vector2i):
	var shifted_tiles_to_carve: Array[Vector2i] = []
	var shifted_tiles_to_wall: Array[Vector2i] = []
	for vector in tiles_to_carve:
		shifted_tiles_to_carve.append(vector + amount)
	for vector in tiles_to_wall:
		shifted_tiles_to_wall.append(vector + amount)
	tiles_to_carve = shifted_tiles_to_carve
	tiles_to_wall = shifted_tiles_to_wall
