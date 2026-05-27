class_name EventAnimation
extends Object

var game: Game
var grid_position: Vector2i
var target: Entity
var interrupt: bool
var tween: Tween
var tiles: MapData
var image: Sprite2D


func _init(in_game: Game, in_tween: Tween, entity: Entity, position: Vector2i, interruption: bool):
	game = in_game
	grid_position = position
	target = entity
	interrupt = interruption
	tween = in_tween
	tiles = game.get_map_data()

	if interrupt:
		tween.finished.connect(_tween_finished)
		_tween_started()

func play():
	tween.play()	
		
func end():
	tween.kill()
	if interrupt:
		_tween_finished()

func _tween_finished():
	game.interruptions -= 1

func _tween_started():
	game.interruptions += 1
