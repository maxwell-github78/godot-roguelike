extends Sprite2D

var time: float = 0.0
const duration: float = 2.0
var disintegrating: bool = false
var tween: Tween


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	material.set_shader_parameter("our_texture", texture)
	if Input.is_action_just_pressed("ui_accept"):
		if tween:
			tween.kill()
		tween = create_tween()
		if disintegrating:
			tween.tween_method(change_disintegrate, time, 0.0, duration).set_ease(Tween.EASE_IN)
		else:
			tween.tween_method(change_disintegrate, time, 1.0, duration).set_ease(Tween.EASE_IN)
		disintegrating = not disintegrating

func change_disintegrate(value: float) -> void:
	time = value
	material.set_shader_parameter("time", time)
