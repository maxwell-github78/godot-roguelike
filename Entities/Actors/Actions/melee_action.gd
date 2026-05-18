class_name MeleeAction
extends ActionWithDirection

const time: float = 0.1

func perform(game: Game, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	var target: Entity = game.get_map_data().get_blocking_entity_at_location(destination)
	if not target:
		return
	if target.health_component:
		target.health_component.hp -= entity.get_entity_power()
	var tween = entity.create_tween()
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(entity.grid_position)) + 0.2 * Grid.grid_to_world(offset), 0.1)
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(entity.grid_position)), 0.1)
	#print(entity.get_entity_name() + " kicks the %s, much to its annoyance!" % target.get_entity_name())
	MovementAnimation.new(game, tween, entity, entity.grid_position, destination, true, false)
