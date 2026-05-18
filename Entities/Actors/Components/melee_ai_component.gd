class_name MeleeEnemyAIComponent
extends BaseAIComponent


var path: Array = []
var target: Entity

func get_action() -> Action:
	if not target:
		for possible in get_map_data().entities:
			if possible.team in entity.enemy_teams: #Reprogram to pick closest, later can be using a targetting component
				target = possible
	var target_grid_position: Vector2i = target.grid_position
	var offset: Vector2i = target_grid_position - entity.grid_position
	var distance: int = max(abs(offset.x), abs(offset.y))
	
	if get_map_data().get_tile(entity.grid_position).is_in_view:
		if distance <= 1:
			return MeleeAction.new(offset.x, offset.y)
		
		path = get_point_path_to(target_grid_position)
		path.pop_front()
	
	if not path.is_empty():
		var destination := Vector2i(path[0])
		if get_map_data().get_blocking_entity_at_location(destination):
			return WaitAction.new()
		path.pop_front()
		var move_offset: Vector2i = destination - entity.grid_position
		return MovementAction.new(move_offset.x, move_offset.y)
		
	return WaitAction.new()
