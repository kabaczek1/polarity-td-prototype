extends Button

@export var building_index:int
@export var label:String
@export var cost:int

signal build_button_pressed(index)

func _ready():
	text = " %d - %s(%d)" % [building_index+1, label, cost]
	Score.score_changed.connect(_on_score_changed)
	_on_score_changed()

func _on_score_changed():
	if Score.value >= cost:
		modulate.a = 1
	else:
		modulate.a = 0.3

func _pressed():
	if cost <= Score.value:
		emit_signal("build_button_pressed", building_index)
	else:
		print("no minerals")
