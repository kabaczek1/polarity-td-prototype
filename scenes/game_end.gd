extends Node2D

@export var text = "You win!"
@onready var label = $PanelContainer/VBoxContainer/Label
@onready var button = $PanelContainer/VBoxContainer/Button

func _ready():
	label.text = text
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().quit()
