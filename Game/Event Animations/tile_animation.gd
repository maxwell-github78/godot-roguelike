class_name TileAnimation
extends EventAnimation

var sprite: AnimatedSprite2D
var key: String

func _init(in_game: Game, animated_sprite: AnimatedSprite2D, in_key: String, manager: Node2D, position: Vector2i, interruption: bool):
	game = in_game
	grid_position = position
	interrupt = interruption
	sprite = animated_sprite
	key = in_key
	sprite.position = Grid.grid_to_world(grid_position)
	manager.add_child(sprite)
	tiles = game.get_map_data()
	sprite.animation_finished.connect(end)
	
func end():
	sprite.queue_free()

func play():
	sprite.play(key)
	visibility()
	
func visibility():
	if tiles.get_tile(grid_position).is_in_view :
		sprite.visible = true
	else:
		sprite.visible = false
	
	
