class_name InputHandler
extends Node

const input_directions: Dictionary[String, Vector2i] = {
	"ui_left_up": Vector2i(-1, -1),
	"ui_left": Vector2i(-1, 0),
	"ui_left_down": Vector2i(-1, 1),
	"ui_down": Vector2i(0, 1),
	"ui_right_down": Vector2i(1, 1),
	"ui_right": Vector2i(1, 0),
	"ui_right_up": Vector2i(1, -1),
	"ui_up": Vector2i(0, -1)
}

@onready var game: Game = get_parent()

func get_action() -> Action:
	var action: Action = null
	
	for direction in input_directions:
		if Input.is_action_just_pressed(direction):
			var offset = input_directions[direction]
			action = BumpAction.new(offset.x, offset.y)
	
	
	if Input.is_action_just_pressed("ui_space"):
		action = WaitAction.new()
	
	if Input.is_action_just_pressed("ui_click"):
		var input_position: Vector2i = game.camera.get_global_mouse_position()
		var map_data: MapData = game.get_map_data()
		var target: Vector2i = Grid.world_to_grid(input_position)
		var current = game.player_controlled_entity.grid_position
		if map_data.get_tile(target).is_explored:
			var delta: Vector2i = target - current
			if delta in input_directions.values():
				action = BumpAction.new(delta.x, delta.y)
			else:
				var path := map_data.pathfinder.get_point_path(current, target)
				if path.size() > 1:
					var next = Vector2i(path[1])
					var offset = next - current
					action = BumpAction.new(offset.x, offset.y)
			
	
	elif Input.is_action_just_pressed("ui_cancel"):
		action = EscapeAction.new()
	
	
	return action
