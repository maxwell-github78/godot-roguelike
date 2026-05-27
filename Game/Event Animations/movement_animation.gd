class_name MovementAnimation
extends EventAnimation


var start_grid_position: Vector2i
var end_grid_position: Vector2i
var make_afterimage: bool

func _init(in_game: Game, in_tween: Tween, entity: Entity, start: Vector2i, destination: Vector2i, interruption: bool, afterimage: bool):
	super(in_game, in_tween, entity, start, interruption)
	start_grid_position = grid_position
	end_grid_position = destination
	make_afterimage = afterimage
		
func draw_afterimage():
	if tiles.get_tile(start_grid_position).is_in_view or tiles.get_tile(end_grid_position).is_in_view:
		image = Sprite2D.new()
		game.map.animation_sprites.add_child(image)
		image.texture = target.get_entity_texture()
		image.position = Grid.grid_to_world(start_grid_position)
		image.centered = false
		var fade_tween = image.create_tween()
		image.modulate.a = 0.5
		fade_tween.tween_property(image, "modulate:a", 0.0, 1.0)
		fade_tween.finished.connect(kill_afterimage)
	

func kill_afterimage():
	image.queue_free()

func play():
	super()	
	visibility()
	
func visibility():
	if tiles.get_tile(start_grid_position).is_in_view or tiles.get_tile(end_grid_position).is_in_view:
		target.visible = true
	else:
		target.visible = false
