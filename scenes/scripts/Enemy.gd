extends CharacterBody2D

@export_range(0, 200) var speed: int = 35
@export_enum("Left:-1", "Right:1") var move_direction: int = -1
@export_range(0, 20) var damage: int = 1
@export var score: int = 3
@export var direction_vector: Vector2 = Vector2(1, 0)
#(x - (1: right, -1: left), y - (1: down, -1: up))
@onready var direction = direction_vector.normalized()

func set_direction_vector(v: Vector2):
	direction_vector = v

func _physics_process(_delta):
	velocity = Vector2(direction_vector.x * speed, 0)
	move_and_slide()

func _exit_tree():
	Score.change_value(score)
