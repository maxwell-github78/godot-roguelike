extends Node2D

@warning_ignore("unused_signal") #Used by children
signal new_entity(entity: Entity)

@warning_ignore("unused_signal")
signal removed_entity(entity: Entity)
