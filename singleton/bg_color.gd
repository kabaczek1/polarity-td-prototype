extends Node

@export var color:Color = Color(0,0,0,1)

signal color_changed

func _ready():
	RenderingServer.set_default_clear_color(color)

func change_bg_color(new_color:Color):
	color = new_color
	color_changed.emit()
	RenderingServer.set_default_clear_color(color)
