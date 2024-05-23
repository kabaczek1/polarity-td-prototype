extends Node

@export var value:int = 6
@export var label:String = "Energy"
@export var divider:String = ": "
@export var max_value:int = 100
@export var goal:int = 200

signal score_changed

func _to_string():
	return str(value)

func change_value(points: int):
	var new_value = clamp(value + points, 0, max_value)
	if not value == new_value:
		value = new_value
		score_changed.emit()
		if value >= goal:
			goal_reached()

func change_max_value(points: int):
	max_value += points
	score_changed.emit()

func goal_reached():
	SceneManager._on_win()
