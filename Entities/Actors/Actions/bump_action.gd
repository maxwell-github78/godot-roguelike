class_name BumpAction
extends ActionWithDirection


func perform(game: Game, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	
	var blocking_entity := game.get_map_data().get_blocking_entity_at_location(destination)
	#if blocking_entity:
		#assert(blocking_entity.position == Vector2(Grid.grid_to_world(blocking_entity.grid_position)))
	if blocking_entity and blocking_entity.team in entity.enemy_teams:
		game.event_queue.push_front(Event.new(MeleeAction.new(offset.x, offset.y), entity))	
	else:
		game.event_queue.push_front(Event.new(MovementAction.new(offset.x, offset.y), entity))	
