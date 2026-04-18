class_name Tile
extends Sprite2D

var _definition: TileDefinition
var side: bool = false
var has_side: bool = false

var is_explored: bool = false:
	set(value):
		is_explored = value
		if is_explored and not visible:
			visible = true
			
var is_in_view: bool = false:
	set(value):
		is_in_view = value
		modulate = Color(1.0, 1.0, 1.0) if is_in_view else Color(0.3, 0.3, 0.3)
		if is_in_view and not is_explored:
			is_explored = true
	

func _init(grid_position: Vector2i, tile_definition: TileDefinition) -> void:
	visible = false
	centered = false
	position = Grid.grid_to_world(grid_position)
	set_tile_type(tile_definition)
	
	
func set_tile_type(tile_definition: TileDefinition) -> void:
	_definition = tile_definition
	texture = tile_definition.texture
	has_side = tile_definition.has_side
	
func set_autotiling() -> void:
	if side:
		texture = _definition.side_texture
	
func get_tile_type() -> TileDefinition:
	return _definition
	
func is_walkable() -> bool:
	return _definition.is_walkable


func is_transparent() -> bool:
	return _definition.is_transparent
	
