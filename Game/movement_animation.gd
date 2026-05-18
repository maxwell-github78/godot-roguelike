class_name MovementAnimation
extends Object

var game: Game
var start_grid_position: Vector2i
var end_grid_position: Vector2i
var entity: Entity
var interrupt: bool
var make_afterimage: bool
var tween: Tween
var tiles: MapData
var image: Sprite2D


func _init(in_tween: Tween, in_entity: Entity, start: Vector2i, destination: Vector2i, interruption: bool, afterimage: bool):
	start_grid_position = start
	end_grid_position = destination
	entity = in_entity
	interrupt = interruption
	make_afterimage = afterimage
	tween = in_tween

func add(in_game: Game):
	game = in_game
	tiles = game.get_map_data()
	entity.add_animation(self)

	if interrupt:
		tween.finished.connect(_tween_finished)
		_tween_started()
		
func draw_afterimage():
	if tiles.get_tile(start_grid_position).is_in_view or tiles.get_tile(end_grid_position).is_in_view:
		image = Sprite2D.new()
		game.map.animation_sprites.add_child(image)
		image.texture = entity.get_entity_texture()
		image.position = Grid.grid_to_world(start_grid_position)
		image.centered = false
		var fade_tween = image.create_tween()
		image.modulate.a = 0.5
		fade_tween.tween_property(image, "modulate:a", 0.0, 1.0)
		fade_tween.finished.connect(kill_afterimage)
	

func kill_afterimage():
	image.queue_free()

func end():
	tween.kill()
	if interrupt:
		_tween_finished()

func play():
	tween.play()	
	visibility()
	
func visibility():
	if tiles.get_tile(start_grid_position).is_in_view or tiles.get_tile(end_grid_position).is_in_view:
		entity.visible = true
	else:
		entity.visible = false

func _tween_finished():
	game.interruptions -= 1

func _tween_started():
	game.interruptions += 1
