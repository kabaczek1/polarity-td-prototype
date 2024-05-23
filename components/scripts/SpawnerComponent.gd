extends Node2D
class_name SpawnerComponent

@export var scene:PackedScene
@export_range(0, 20) var wait_time: float = 1
@export var start_enabled:bool = false
@export var direction_vector: Vector2 = Vector2(1, 0)
#(x - (1: right, -1: left), y - (1: down, -1: up))
@onready var direction = direction_vector.normalized()

func _ready():
	var parent = get_parent()
	if parent.has_method("get_direction_vector"):
		direction_vector = parent.get_direction_vector()
	if parent.has_signal("tower_enabled"):
		parent.tower_enabled.connect(spawn)
	if parent.has_signal("direction_vector_changed"):
		parent.direction_vector_changed.connect(set_direction_vector)
	if start_enabled:
		spawn()

func spawn():
	if not get_tree().paused:
		var instance = scene.instantiate()
		if instance.has_method("set_direction_vector"):
			instance.set_direction_vector(direction_vector)
		add_child(instance)
	get_tree().create_timer(wait_time).timeout.connect(spawn)

func set_direction_vector(v: Vector2):
	direction_vector = v

func _on_enable():
	pass
