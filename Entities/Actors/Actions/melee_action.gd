class_name MeleeAction
extends ActionWithDirection

func perform(game: Game, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	var target: Entity = game.get_map_data().get_blocking_entity_at_location(destination)
	if not target:
		return
		
	var trans := Tween.TRANS_SPRING
	var movement_tween := entity.create_tween()
	movement_tween.tween_property(entity, "position", 
	Vector2(Grid.grid_to_world(entity.grid_position)) + 0.5 * Vector2(Grid.grid_to_world(offset)),
	 0.1).set_trans(trans)
	movement_tween.tween_property(entity, "position", 
	Vector2(Grid.grid_to_world(entity.grid_position)), 0.1).set_trans(trans)
	#print(entity.get_entity_name() + " kicks the %s, much to its annoyance!" % target.get_entity_name())
