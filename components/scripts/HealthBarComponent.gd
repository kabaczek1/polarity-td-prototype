extends Node2D
class_name HealthBarComponent

@onready var texture_progress_bar = $TextureProgressBar
@export var health_component : HealthComponent
@export_enum("TextureProgressBar:0", "ProgressBar:1") var mode: int = 1
@onready var progress_bar = $ProgressBar

func _ready():
	texture_progress_bar.max_value = health_component.MAX_HEALTH
	texture_progress_bar.value = health_component.MAX_HEALTH
	progress_bar.max_value = health_component.MAX_HEALTH
	progress_bar.value = health_component.MAX_HEALTH
	health_component.damage_taken.connect(_on_health_component_damage_taken)
	if mode == 0:
		progress_bar.hide()
	if mode == 1:
		texture_progress_bar.hide()

func _on_health_component_damage_taken(hp:int):
	texture_progress_bar.value = hp
	progress_bar.value = hp
