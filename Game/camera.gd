
extends Camera2D

@export var follow_speed: float
@export var zoom_speed: float


func _ready() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = follow_speed

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			set_zoom(zoom + Vector2(zoom_speed, zoom_speed))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			set_zoom(zoom - Vector2(zoom_speed, zoom_speed))
			
