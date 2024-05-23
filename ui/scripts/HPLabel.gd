extends Label

@export var health_component : HealthComponent

func _ready():
	text = "HP: %d/%d" % [health_component.get_health(), health_component.MAX_HEALTH]
	health_component.damage_taken.connect(_on_health_component_damage_taken)

func _on_health_component_damage_taken(hp:int):
	text = "HP: %d/%d" % [hp, health_component.MAX_HEALTH]
