extends Node

signal light_debug_changed

@export var all_lit: bool = false:
	set(value):
		light_debug_changed.emit(value)
