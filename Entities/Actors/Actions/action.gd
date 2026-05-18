class_name Action
extends RefCounted

var entity: Entity

func _init(in_entity: Entity) -> void:
	entity = in_entity


func perform() -> void:
	pass


func get_map_data() -> MapData:
	return entity.map_data
