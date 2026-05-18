class_name MeleeAction
extends ActionWithDirection

const time: float = 0.1

signal new_animation(animation: MovementAnimation)

func perform() -> void:
	var target: Entity = get_blocking_entity_at_destination()
	if not target:
		return
		
	print("You kick the %s, much to it's annoyance!" % target.get_entity_name())
		
	var tween = entity.create_tween()
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(entity.grid_position)) + 0.2 * Grid.grid_to_world(offset), 0.1)
	tween.tween_property(entity, "position", Vector2(Grid.grid_to_world(entity.grid_position)), 0.1)
	#print(entity.get_entity_name() + " kicks the %s, much to its annoyance!" % target.get_entity_name())
	new_animation.emit(MovementAnimation.new(tween, entity, entity.grid_position, get_destination(), true, false))
	
