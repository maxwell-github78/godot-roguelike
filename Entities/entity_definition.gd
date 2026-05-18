class_name EntityDefinition
extends Resource

@export_category("Visuals")
@export var name: String = "Unnamed Entity"
@export var texture: AtlasTexture

@export_category("Mechanics")
@export var speed: int = 25
@export var max_hp: int = 100
@export var power: int = 30 #TEMPORARY
@export var team: String
@export var enemy_teams: Array[String]
@export var is_blocking_movement: bool = true
@export var is_player_controlled: bool = false

@export_category("Components")
@export var ai_type: Entity.AIType
