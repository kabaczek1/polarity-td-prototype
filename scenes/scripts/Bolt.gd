extends Node2D

@export_range(0, 500) var speed: int = 100
#@export_enum("Left:-1", "Right:1") var move_direction: int = 1
@export var direction_vector: Vector2 = Vector2(1, 0)
#(x - (1: right, -1: left), y - (1: down, -1: up))
@onready var direction = direction_vector.normalized()
@onready var viewport_rect_size = get_viewport_rect().size
@export var bolt_range: int = 192

var start_pos


#@onready var random_direction = Vector2((randf()*2)-1, (randf()*2)-1).normalized()
func _ready():
	start_pos = position

func _physics_process(delta):
	global_position += direction * speed * delta
	if left_scren():
		#print("queue_free")
		queue_free()
	if start_pos.distance_to(position) >= bolt_range:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0,0), 0.15)
		tween.tween_callback(self.queue_free)

func set_direction_vector(v: Vector2):
	direction_vector = v.normalized()

func left_scren():
	var offset = 30
	if global_position.x > viewport_rect_size.x + offset:
		#print("off screen to the right")
		return true
	if global_position.x < 0 - offset:
		#print("off screen to the left")
		return true
	if global_position.y > viewport_rect_size.y + offset:
		#print("below the screen")
		return true
	if global_position.y < 0 - offset:
		#print("above the scrren")
		return true
	return false
