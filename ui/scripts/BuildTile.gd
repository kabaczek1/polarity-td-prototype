extends Node2D
class_name BuildTile

@export var vector: Vector2i = Vector2i(0,0)

@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D

func _ready():
	hide_tile()
	Grid.build_mode_entered.connect(show_tile)
	Grid.build_mode_left.connect(hide_tile)
	Grid.tower_destroyed.connect(func ():
		if Grid.build_mode:
			if Grid.is_placement_valid(vector):
				sprite_2d.show()
			else:
				sprite_2d.hide()
	)
	#print(vector, " pos: ", position)
	#area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)
	#area_2d.mouse_exited.connect(_on_area_2d_mouse_exited)


func show_tile():
	if Grid.is_placement_valid(vector):
		sprite_2d.show()


func hide_tile():
	sprite_2d.hide()


#func _on_area_2d_mouse_entered():
	#if Grid.build_mode and Grid.is_placement_valid(vector):
		#Grid._on_tile_hover_entered(vector, position)
#
#func _on_area_2d_mouse_exited():
	#if Grid.build_mode and Grid.is_placement_valid(vector):
		#Grid._on_tile_hover_exited(vector)
