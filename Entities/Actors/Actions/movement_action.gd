class_name MovementAction
extends ActionWithDirection


func perform(game: Game, entity: Entity) -> void:
	if entity.is_player_controlled:
		print("moving, not attacking")
	var destination: Vector2i = entity.grid_position + offset
	var map_data: MapData = game.get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	if not destination_tile or not destination_tile.is_walkable():
		return
	if game.get_map_data().get_blocking_entity_at_location(destination):
		return
	var tween = entity.create_tween()
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(destination)), 0.1)
	MovementAnimation.new(game, tween, entity, entity.grid_position, destination, false, true)
	
	entity.move(offset)
	
	
