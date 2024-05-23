extends Area2D
class_name DamageComponent

@export var damage : int = 1
@export var group = "enemy"

func _on_area_entered(area):
	#print(get_parent().name, " ", area.name, " ", area.get_parent().name)
	if area.owner.is_in_group(group):
		if area.has_method("take_damage"):
			area.take_damage(damage)
			get_parent().queue_free()
