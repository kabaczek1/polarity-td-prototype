extends Node2D

#@export var grid_cell: Vector2i

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.RED, EnemyConductor.indicators_time).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self.queue_free)

#func set_grid_cell(new_grid_cell: Vector2i):
	#grid_cell = new_grid_cell
	#EnemyConductor.change_indicator.connect(func (cell: Vector2i, state: bool):
		#if(grid_cell == cell):
			#if state:
				#show()
			#else:
				#hide()
	#)

func flip_sprite():
	var sprite_2d = $Sprite2D
	sprite_2d.flip_h = true
