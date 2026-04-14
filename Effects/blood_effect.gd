extends AnimatedSprite2D
class_name BloodEffect



func _on_animation_finished() -> void:
	queue_free()
