extends TextureButton

@export var building: PackedScene
var cost: int
var label: String
var message: String
var key: int
var hp: int
var desc: String

func build():
	Grid.enter_build_mode(building)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == key:
			if not Grid.build_mode:
				_pressed()

func _ready():
	Grid.build_mode_left.connect(_on_grid_build_mode_left)
	Grid.build_mode_entered.connect(_on_grid_build_mode_entered)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	var temp = building.instantiate()
	label = temp.name
	cost = temp.cost
	key = temp.key
	hp = temp.hp
	desc = temp.desc
	message = "%s (cost: %d, hp: %d) %s" % [label, cost, hp, desc]
	temp.queue_free()
	Score.score_changed.connect(_on_score_changed)
	_on_score_changed()

func _on_score_changed():
	if Score.value >= cost:
		modulate.a = 1
	else:
		modulate.a = 0.5

func _pressed():
	if cost <= Score.value:
		build()
	else:
		InfoMsg.send("Not enough energy", 0)

func _on_mouse_entered():
	InfoMsg.send(message, 0)

func _on_mouse_exited():
	InfoMsg.clear()

func _on_grid_build_mode_entered():
	disabled = true
	modulate.a = 0.3

func _on_grid_build_mode_left():
	disabled = false
	_on_score_changed()
