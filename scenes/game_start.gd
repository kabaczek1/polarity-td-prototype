extends Node2D

@onready var start_button = $PanelContainer/VBoxContainer/StartButton

func _ready():
	get_tree().paused = true
	start_button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().paused = false
	EnemyConductor._on_game_start()
	queue_free()
