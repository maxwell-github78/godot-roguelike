class_name FighterComponent
extends Component

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
var defense: int
var power: int


func _init() -> void:
	pass
