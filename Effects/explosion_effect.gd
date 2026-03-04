extends Node2D
class_name ExplosionEffect


func _on_animation_finished() -> void:
	queue_free()
