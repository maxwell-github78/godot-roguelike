class_name Event
extends Object

var action: Action
var target: Entity 

func _init(event_action: Action, target_entity: Entity) -> void:
	action = event_action
	target = target_entity
	
