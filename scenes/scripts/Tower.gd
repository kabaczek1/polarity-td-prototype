extends Node2D
class_name Tower

signal tower_enabled
signal tower_disabled
signal direction_vector_changed(v: Vector2)
signal tower_destroyed

@export var state:bool = false
@export var caps_top:bool = false
@export var caps_bottom:bool = false
@export var cost:int = 3
@export var hp:int = 3
@export var key:int = KEY_1
@export var desc:String = ""
@export var allowed_layers:Array[int] = [6, 7]
@export var direction_vector: Vector2 = Vector2(1, 0)
#(x - (1: right, -1: left), y - (1: down, -1: up))
@onready var direction = direction_vector.normalized()

@onready var health_component = $HealthComponent


var grid_cell: Vector2i
var collider:CollisionShape2D

func _ready():
	health_component.set_max_health(hp)
	collider = get_node("HitboxComponent/CollisionShape2D")
	Grid.tower_destroy.connect(_on_tower_destroy)
	self.tree_exiting.connect(func ():
		Grid._on_building_destroyed(grid_cell, caps_top, caps_bottom)
	)
	if state:
		enable()
	else:
		disable()

func enable():
	tower_enabled.emit()
	modulate.a = 1
	collider.set_disabled(false)
	$HealthBarComponent.show()
	state = true

func disable():
	tower_disabled.emit()
	modulate.a = 0.3
	collider.set_disabled(true)
	$HealthBarComponent.hide()
	state = false

func get_direction_vector():
	return direction_vector

func set_direction_vector(v: Vector2):
	direction_vector_changed.emit(v)
	direction_vector = v

func set_grid_cell(v: Vector2i):
	grid_cell = v

func _on_tower_destroy(v: Vector2i):
	#print("_on_tower_destroy", grid_cell)
	#print(grid_cell, " == ", v)
	#print(grid_cell == v)
	if grid_cell == v:
		queue_free()

func is_enabled():
	return state

func validate_placement(v: Vector2i):
	if v.y in allowed_layers:
		if not Grid.empty_cell_below(v) or v.y == 6:
			if v.y >= 6:
				if Grid.get_top_cap(v.x):
					return false
			if v.y <= 5:
				if Grid.get_bottom_cap(v.x):
					return false
			return true
	return false
