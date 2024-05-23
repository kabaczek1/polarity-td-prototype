extends VBoxContainer

@export var buildings: Array[PackedScene]

var build_button = preload("res://ui/build_button.tscn")

func _ready():
	Grid.build_mode_left.connect(show)
	var i = 0
	for item in buildings:
		var temp = item.instantiate()
		var button = build_button.instantiate()
		button.label = temp.name
		button.cost = temp.cost
		button.building_index = i
		button.build_button_pressed.connect(build)
		add_child(button)
		temp.queue_free()
		i += 1

func build(index:int):
	Grid.enter_build_mode(buildings[index])
	hide()
	#var instance = buildings[index].instantiate()
	#instance.position = get_viewport().get_mouse_position()
	#add_sibling(instance)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			build(0)
		if event.keycode == KEY_2:
			build(1)
		if event.keycode == KEY_3:
			build(2)
		#if event.keycode == KEY_4:
			#build(3)
		#if event.keycode == KEY_5:
			#build(4)
		#if event.keycode == KEY_6:
			#build(5)
		#if event.keycode == KEY_7:
			#build(6)
		#if event.keycode == KEY_8:
			#build(7)
		#if event.keycode == KEY_9:
			#build(8)
