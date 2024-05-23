extends Node

var current_scene
var base_hp_box

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	base_hp_box = current_scene.get_node("BaseHPBox")
	var hp_comp = base_hp_box.get_node("HealthComponent")
	hp_comp.dead.connect(_on_defeat)

func _on_defeat():
	print("_on_defeat")
	get_tree().paused = true
	get_tree().create_timer(2).timeout.connect(func ():
		self.call_deferred("show_game_end_screen")
	)

func _on_win():
	get_tree().paused = true
	get_tree().create_timer(2).timeout.connect(func ():
		self.call_deferred("show_game_end_screen_win")
	)

func show_game_end_screen():
	get_tree().change_scene_to_file("res://scenes/game_end.tscn")

func show_game_end_screen_win():
	get_tree().change_scene_to_file("res://scenes/game_end_win.tscn")
