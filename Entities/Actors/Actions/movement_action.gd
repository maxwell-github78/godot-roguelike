class_name MovementAction
extends ActionWithDirection

signal new_animation(animation: MovementAnimation)

func perform() -> void:
	if entity.is_player_controlled:
		print("moving, not attacking")
	var destination: Vector2i = entity.grid_position + offset
	var destination_tile: Tile = get_map_data().get_tile(destination)
	if not destination_tile or not destination_tile.is_walkable():
		return
	if get_blocking_entity_at_destination():
		return
	var tween = entity.create_tween()
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(destination)), 0.1)
	new_animation.emit(MovementAnimation.new(tween, entity, entity.grid_position, get_destination(), false, true))
	
	entity.move(offset)
	
	
