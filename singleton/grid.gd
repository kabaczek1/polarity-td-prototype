extends Node

var tile_map
var current_scene = null
var build_tile = preload("res://ui/BuildTile.tscn")
var build_mode = false

var building_instance
var building_snapped = false

signal build_mode_entered
signal build_mode_left
signal tower_destroy(v: Vector2)
signal tower_destroyed

var start_position
var grid_size = Vector2i(36,20)
var grid_start = Vector2i(0, 19)

var bit_map = BitMap.new()
var col_map = []

# https://github.com/godotengine/godot-proposals/issues/5148
# https://docs.godotengine.org/en/stable/classes/class_bitmap.html

#func set_grid_data(v: Vector2i, data):
	#grid_data[v.x][v.y] = data
#
#func get_grid_data(v: Vector2i):
	#return grid_data[v.x][v.y]

func is_placement_valid(v: Vector2i):
	if bit_map.get_bitv(v):
		if building_instance.validate_placement(v):
			return true
	return false



#func _on_tile_hover_entered(v: Vector2i, pos):
	#print("enter", v)
	#building_snapped = true
	#var tween = get_tree().create_tween()
	#tween.tween_property(building_instance, "position", pos, 0.1)
	##building_instance.position = pos
#
#func _on_tile_hover_exited(v: Vector2i):
	#print("exited", v)
	#building_snapped = false

func position_to_grid(v: Vector2):
	return Vector2i(
		(v.x / 32) - grid_start.x,
		#(v.x / 32) - grid_start.x,
		((grid_start.y + 1) * 32 - v.y) / 32 #max560
		#(grid_start.y * 32 - v.y) / 32
		#((grid_start.y - v.y) / 32) + grid_start.y - 16
		#(v.y / 32) - grid_start.y
		#min((v.y / 32) - grid_start.y, 0)
		#abs(min((v.y / 32) - grid_start.y, 0))
	)

func grid_to_position(v: Vector2i):
	return Vector2i(
		start_position.x + v.x * 32,
		start_position.y - v.y * 32
	)

func snapped_position(v: Vector2):
	return grid_to_position(position_to_grid(v))

func enter_build_mode(scene: PackedScene):
	if build_mode:
		return
	building_instance = scene.instantiate()
	var mouse_position = get_viewport().get_mouse_position()
	if is_placement_valid(position_to_grid(mouse_position)):
		building_snapped = true
		building_instance.position = snapped_position(mouse_position)
	else:
		building_instance.position = mouse_position
	build_mode_entered.emit()
	build_mode = true
	#print("build mode: on")
	#print(building_instance)
	current_scene.add_child(building_instance)

func empty_cell_below(v: Vector2i):
	return bit_map.get_bitv(v + Vector2i(0,-1))

func empty_cell_above(v: Vector2i):
	return bit_map.get_bitv(v + Vector2i(0,1))

enum col_state {TOP_CAP = 1, BOTTOM_CAP = 2}

func get_top_cap(col: int):
	return not col_map[col] & col_state.TOP_CAP == 0

func get_bottom_cap(col: int):
	return not col_map[col] & col_state.BOTTOM_CAP == 0

func set_col_map(col: int, state: col_state):
	col_map[col] = col_map[col] | state

func clear_col_map(col: int, state: col_state):
	col_map[col] = col_map[col] - state

func place_building():
	#print("place")
	if building_snapped:
		building_snapped = false
		var grid_cell = position_to_grid(building_instance.position)
		#print("gc: ", grid_cell)
		bit_map.set_bitv(grid_cell, false)
		building_instance.set_grid_cell(grid_cell)
		if building_instance.has_method("set_direction_vector"):
			if grid_cell.x > 17:
				building_instance.set_direction_vector(Vector2(1,0))
			else:
				building_instance.set_direction_vector(Vector2(-1,0))
		if building_instance.caps_top:
			#set_top_cap(grid_cell.x)
			set_col_map(grid_cell.x, col_state.TOP_CAP)
		if building_instance.caps_bottom:
			#set_bottom_cap(grid_cell.x)
			set_col_map(grid_cell.x, col_state.BOTTOM_CAP)
		#print("col_map: ", col_map[grid_cell.x])
		#print("TOP_CAP: ", get_top_cap(grid_cell.x))
		#print("BOTTOM_CAP: ", get_bottom_cap(grid_cell.x))
		#print("0b01 & 0b10: ", 0b01 & 0b10)
		Score.change_value(building_instance.cost * -1)
		building_instance.enable()
		#print("ecb: ", empty_cell_below(grid_cell))
		exit_build_mode()
	else:
		InfoMsg.send("Cannot build here!", 2)

func _on_building_destroyed(grid_cell, caps_top, caps_bottom):
	#print("_on_building_destroyed", grid_cell)
	bit_map.set_bitv(grid_cell, true)
	if caps_top:
		clear_col_map(grid_cell.x, col_state.TOP_CAP)
	if caps_bottom:
		clear_col_map(grid_cell.x, col_state.BOTTOM_CAP)
	#print("not empty_cell_above ", not empty_cell_above(grid_cell))
	tower_destroyed.emit()
	if not empty_cell_above(grid_cell):
		#print("tower_destroy", grid_cell + Vector2i(0,1))
		tower_destroy.emit(grid_cell + Vector2i(0,1))

func exit_build_mode():
	build_mode_left.emit()
	build_mode = false
	#print("build mode: off")

func cancel_building():
	building_instance.queue_free()
	exit_build_mode()

func _input(event):
	if build_mode:
		if event is InputEventMouseButton and event.get_button_index() == 1:
			place_building()
		if event is InputEventMouseButton and event.get_button_index() == 2:
			cancel_building()
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_ESCAPE:
				cancel_building()
		#if event is InputEventMouseButton and event.is_pressed():
			#place_building()
		#if event is InputEventMouseMotion and not building_snapped:
			#building_instance.position = event.position
		if event is InputEventMouseMotion:
			#print("pos2grd", position_to_grid(event.position))
			#print("snapped", snapped_position(event.position))
			if is_placement_valid(position_to_grid(event.position)):
				building_snapped = true
				building_instance.position = snapped_position(event.position)
			else:
				building_snapped = false
				building_instance.position = event.position
			#var tween = create_tween()
			#tween.tween_property(building_instance, "position", snapped_position(event.position), 0.2)

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	tile_map = current_scene.get_node("TileMap")
	start_position = tile_map.map_to_local(grid_start)
	#print(start_position)
	#print(grid_data)
	bit_map.create(grid_size)
	col_map.resize(grid_size.x)
	col_map.fill(0)
	
	var rect = Rect2i(Vector2i(0,0), grid_size)
	bit_map.set_bit_rect(rect, false)
	rect = Rect2i(Vector2i(2,1), grid_size - Vector2i(4,2))
	bit_map.set_bit_rect(rect, true)

	#rect = Rect2i(Vector2i(16,0), Vector2i(1,9))
	#bit_map.set_bit_rect(rect, false)
	#rect = Rect2i(Vector2i(19,0), Vector2i(1,9))
	#bit_map.set_bit_rect(rect, false)

	set_col_map(17, col_state.TOP_CAP)
	set_col_map(18, col_state.TOP_CAP)
	#print("col_map: ", col_map[16])
	#print("TOP_CAP: ", get_top_cap(16))

	#print(bit_map.get_true_bit_count())
	#grid_data = []
	#print(grid_data)
	#grid_data.resize(grid_size.x)
	#grid_data.fill([])
	#print(grid_data)
	#for y in range(grid_size.x):
		#print(y)
		#print(grid_data[y])
		#grid_data[y].resize(grid_size.y)
		#grid_data[y].fill(true)
	#print(grid_data)
	#set_grid_data(Vector2i(5,6), false)
	#grid_data[5][6] = false
	#print(grid_data)
	for x in range(grid_size.x):
		#grid_data[x] = []
		#grid_data[x].fill([])
		for y in range(grid_size.y):
			var instance = build_tile.instantiate()
			instance.vector = Vector2i(x, y)
			instance.position = grid_to_position(instance.vector)
			current_scene.add_child(instance)

func get_coords():
	return tile_map.local_to_map(tile_map.get_local_mouse_position())
