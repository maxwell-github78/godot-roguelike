extends Node

signal light_debug_changed

var all_lit: bool = false:
	set(value):
		all_lit = value
		light_debug_changed.emit(value)

@export var default_all_lit: bool = false:
	set(value):
		all_lit = value
		
		
