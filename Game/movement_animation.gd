class_name MovementAnimation
extends Object

var game: Game
var start_grid_position: Vector2i
var end_grid_position: Vector2i
var target: Entity
var interrupt: bool
var make_afterimage: bool
var tween: Tween
var tiles: MapData
var image: Sprite2D


func _init(in_game: Game, in_tween: Tween, entity: Entity, start: Vector2i, destination: Vector2i, interruption: bool, afterimage: bool):
	game = in_game
	start_grid_position = start
	end_grid_position = destination
	target = entity
	interrupt = interruption
	make_afterimage = afterimage
	tween = in_tween
	tiles = game.get_map_data()
	entity.add_animation(self)

	if interrupt:
		print(self, "start")
		tween.finished.connect(_tween_finished)
		_tween_started()
		
func draw_afterimage():
	if make_afterimage and tiles.get_tile(start_grid_position).is_in_view:
		image = Sprite2D.new()
		game.map.animation_sprites.add_child(image)
		image.texture = target.get_entity_texture()
		image.position = Grid.grid_to_world(start_grid_position)
		image.centered = false
		var fade_tween = image.create_tween()
		image.modulate.a = 0.5
		fade_tween.tween_property(image, "modulate:a", 0.0, 0.5)
		fade_tween.finished.connect(kill_afterimage)
		end()

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
	#print(start_grid_position, end_grid_position)
	if tiles.get_tile(start_grid_position).is_in_view or tiles.get_tile(end_grid_position).is_in_view:
		target.visible = true
		#target.modulate = Color(1,1,1)
	else:
		target.visible = false
		#target.modulate = Color(0,0,1)

func _tween_finished():
	print(self, "end")
	game.interruptions -= 1

func _tween_started():
	game.interruptions += 1
