extends Label

func _ready():
	InfoMsg.info_msg_changed.connect(_on_info_msg_changed)

func _on_info_msg_changed(new_text, wait_time):
	text = new_text
	if wait_time != 0:
		get_tree().create_timer(wait_time).timeout.connect(InfoMsg.clear)
