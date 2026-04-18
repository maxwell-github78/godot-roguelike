class_name TileDefinition
extends Resource

@export_category("Visuals")
@export var texture: AtlasTexture
@export var side_texture: AtlasTexture
@export var has_side: bool = false

@export_category("Mechanics")
@export var is_walkable: bool = true
@export var is_transparent: bool = true
