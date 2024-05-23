extends Node

var ground_enemy = preload("res://scenes/Enemy.tscn")
var sky_enemy = preload("res://scenes/EnemySky.tscn")
var indicator = preload("res://scenes/indicator.tscn")
#var indicator = preload("res://scenes/Wall.tscn")
var current_wave = 0
var indicators_time = 5
@onready var main = $"."

#signal change_indicator(grid_cell: Vector2i, state: bool)

func _ready():
	pass
	#place_indicators()
	##getlocations
#
#func place_indicators():
	#for i in range(Grid.grid_size.y):
		#place_indicator(i, -1)
		#place_indicator(i, 1)

func place_indicator(level, side):
	var instance = indicator.instantiate()
	if(side == -1):
		#instance.set_grid_cell(Vector2i(0, level))
		instance.position = Grid.grid_to_position(Vector2i(0, level))
		instance.flip_sprite()
	if(side == 1):
		#instance.set_grid_cell(Vector2i(35, level))
		instance.position = Grid.grid_to_position(Vector2i(35, level))
	#instance.hide()
	add_child(instance)

func _on_game_start():
	wave()

func get_spawn_position(level: int, side: int):
	#print("get_spawn_position(level: ", level, ", side: ", side, ")")
	var v = Vector2i(0,level)
	if side == 1:
		v += Vector2i(36,0)
	var position = Grid.grid_to_position(v)
	position += Vector2i(side * 32, 0)
	#print("position: ", position)
	return position

func spawn(level: int, side: int):
	var scene
	if level == 6:
		scene = ground_enemy
	if level >= 7:
		scene = sky_enemy
	if get_tree().paused:
		return
	var instance = scene.instantiate()
	instance.position = get_spawn_position(level, side)
	if instance.has_method("set_direction_vector"):
		instance.set_direction_vector(Vector2i(-1 * side ,0))
	main.add_child(instance)

func spawn_line(level: int, side: int, count: int, time_gap: float):
	for i in range(count):
		var time = (i + 1) * time_gap
		get_tree().create_timer(time).timeout.connect(spawn.bind(level, side))

func wait_then_spawn_line(wait_time: float, level: int, side: int, count: int, time_gap: float):
	var time = wait_time - indicators_time
	if time <= 0:
		print("be sure to allow time for indicator")
		return
	get_tree().create_timer(time).timeout.connect(show_indicator_then_spawn_line.bind(level, side, count, time_gap))

func show_indicator_then_spawn_line(level: int, side: int, count: int, time_gap: float):
	place_indicator(level, side)
	get_tree().create_timer(indicators_time).timeout.connect(spawn_line.bind(level, side, count, time_gap))

func wave():
	#get_tree().create_timer(indicators_time).timeout.connect(spawn_lines.bind(current_wave))
	spawn_lines(current_wave)
	current_wave += 1
	InfoMsg.send("wave %d" % current_wave, 2)

func spawn_lines(index: int):
	if index == 0:
		wait_then_spawn_line(10, 6, 1, 6, 2)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 1:
		wait_then_spawn_line(10, 6, 1, 16, 1)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 2:
		wait_then_spawn_line(10, 6, -1, 16, 1)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 3:
		wait_then_spawn_line(10, 7, 1, 6, 2)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 4:
		wait_then_spawn_line(10, 6, 1, 12, 1)
		wait_then_spawn_line(10, 6, -1, 12, 1)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 5:
		wait_then_spawn_line(10, 7, 1, 6, 2)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 6:
		wait_then_spawn_line(10, 7, -1, 10, 1.5)
		wait_then_spawn_line(10, 7, 1, 10, 1.5)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 7:
		wait_then_spawn_line(10, 6, -1, 10, 1.3)
		wait_then_spawn_line(10, 6, 1, 10, 1.3)
		wait_then_spawn_line(10, 7, -1, 10, 1.3)
		wait_then_spawn_line(10, 7, 1, 10, 1.3)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 8:
		wait_then_spawn_line(10, 6, -1, 10, 1.2)
		wait_then_spawn_line(10, 6, 1, 10, 1.2)
		wait_then_spawn_line(10, 7, -1, 10, 1.2)
		wait_then_spawn_line(10, 7, 1, 10, 1.2)
		wait_then_spawn_line(10, 8, -1, 10, 1.2)
		wait_then_spawn_line(10, 8, 1, 10, 1.2)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	if index == 9:
		wait_then_spawn_line(10, 8, -1, 20, 0.4)
		get_tree().create_timer(35).timeout.connect(wave)
		return
	wait_then_spawn_line(10, 6, 1, 15, 1)
	wait_then_spawn_line(10, 7, 1, 15, 1)
	wait_then_spawn_line(10, 8, 1, 15, 1)
	wait_then_spawn_line(10, 9, 1, 15, 1)
	wait_then_spawn_line(10, 6, -1, 15, 1)
	wait_then_spawn_line(10, 7, -1, 15, 1)
	wait_then_spawn_line(10, 8, -1, 15, 1)
	wait_then_spawn_line(10, 9, -1, 15, 1)
	get_tree().create_timer(30).timeout.connect(wave)
	return

#func show_indicator(level: int, side: int):
	#print("show_indicator: ", level_and_side_to_grid_cell(level, side))
	#change_indicator.emit(level_and_side_to_grid_cell(level, side), true)
#
#func hide_indicator(level: int, side: int):
	#print("hide_indicator: ", level_and_side_to_grid_cell(level, side))
	#change_indicator.emit(level_and_side_to_grid_cell(level, side), false)

func level_and_side_to_grid_cell(level: int, side: int):
	var v = Vector2i(0,0)
	if side == 1:
		v += Vector2i(35,0)
	v += Vector2i(0,level)
	return v

# wave: int
# spawnlines: array
	# wait_before, level, direction, count, timegap
