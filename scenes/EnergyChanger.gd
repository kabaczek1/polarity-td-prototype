extends Node

@onready var silo = $".."
@export var energy_change = 50
var is_placed = false

func _ready():
	silo.tower_enabled.connect(func ():
		is_placed = true
		Score.change_max_value(energy_change)
	)
	self.tree_exiting.connect(func ():
		if is_placed:
			Score.change_max_value(-energy_change)
	)
