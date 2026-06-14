extends Node2D
class_name AnimationSprites

@onready var game: Node2D = $"../.."
@onready var packed_scene: PackedScene = preload("res://assets/animations/tile_animations.tscn")

func make_tile_animation(key: String, grid_position: Vector2i):
	var sprite = packed_scene.instantiate()
	var tile_animation := TileAnimation.new(game, sprite, key, self, grid_position, false)
	tile_animation.play()


	
