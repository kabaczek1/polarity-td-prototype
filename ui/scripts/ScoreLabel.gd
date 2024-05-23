extends Label

func _ready():
	_on_score_changed()
	Score.score_changed.connect(_on_score_changed)

func _on_score_changed():
	text = "%s%s%d/%d" % [Score.label, Score.divider, Score.value, Score.max_value]
