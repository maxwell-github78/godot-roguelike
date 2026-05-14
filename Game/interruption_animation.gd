class_name Interruption_Animation
extends Object

var game: Game
var rng := RandomNumberGenerator.new()
var id = rng.randi()

var start_time: float


func _init(in_game: Game, tween: Tween):
	game = in_game
	tween.finished.connect(_finished)
	_started()

func _finished():
	#print("finished", Time.get_unix_time_from_system() - start_time)
	game.interruptions -= 1

func _started():
	#print("started")
	start_time = Time.get_unix_time_from_system()
	game.interruptions += 1
