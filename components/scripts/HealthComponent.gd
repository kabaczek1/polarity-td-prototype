extends Node2D
class_name HealthComponent

signal damage_taken(hp: int)
signal dead

@export_range(0, 60) var MAX_HEALTH:int = 3
var health:int

func _ready():
	health = MAX_HEALTH

func take_damage(damage: int):
	health -= damage
	emit_signal("damage_taken", health)
	if health <= 0:
		dead.emit()
		get_parent().queue_free()

func get_health():
	return health

func set_max_health(hp: int):
	MAX_HEALTH = hp
	health = hp
