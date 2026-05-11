class_name EventHandler
extends Node

@onready var game: Game = get_parent()

func get_action() -> Action:
	var action: Action = null
	
	if Input.is_action_just_pressed("ui_up"):
		action = BumpAction.new(0, -1)
	elif Input.is_action_just_pressed("ui_down"):
		action = BumpAction.new(0, 1)
	elif Input.is_action_just_pressed("ui_left"):
		action = BumpAction.new(-1, 0)
	elif Input.is_action_just_pressed("ui_right"):
		action = BumpAction.new(1, 0)
	
	elif Input.is_action_just_pressed("ui_click"):
		var input_position: Vector2i = game.camera.get_global_mouse_position()
		var map: MapData = game.get_map_data()
		var grid_position: Vector2i = Grid.world_to_grid(input_position)
		var tile: Tile = map.get_tile_xy(grid_position.x, grid_position.y)
		if tile.is_explored: 
			var delta: Vector2i = grid_position - game.player.grid_position
			action = BumpAction.new(delta.x, delta.y)
		
			
	
	elif Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	
	return action
