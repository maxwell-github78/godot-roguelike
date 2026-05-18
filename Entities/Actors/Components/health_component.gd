class_name HealthComponent
extends Component

signal died

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		if hp == 0:
			died.emit()
var power: int


func _init(definition: EntityDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	power = definition.power
