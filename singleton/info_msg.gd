extends Node

#var text: String = ""

signal info_msg_changed(text: String, time: float)

func send(new_text: String, time: float):
	info_msg_changed.emit(new_text, time)

func clear():
	info_msg_changed.emit("", 0)
