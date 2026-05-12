class_name Grid
extends Object
const tile_size = Vector2i(16, 16)

const directions: Array[Vector2i] = [
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1),
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1)
]

static func grid_to_world(grid_pos: Vector2i) -> Vector2i:
	var world_pos: Vector2i = grid_pos * tile_size
	return world_pos
	
static func world_to_grid(world_pos: Vector2i) -> Vector2i:
	var grid_pos: Vector2i = world_pos / tile_size
	return grid_pos
	
static func int_to_direction_eightfold(m: int) -> Vector2i:
	var congruent_m = m % 8
	return directions[congruent_m]
	
static func a_within_b(a: Vector2i, b: Vector2i, distance: int) -> bool:
	return (a.x - b.x)**2 + (a.y - b.y)**2 <= distance**2
