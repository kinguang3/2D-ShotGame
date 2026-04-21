extends Area2D
class_name Portal



func _on_body_entered(body: Node2D) -> void:
	EventBus.on_portal_reach.emit()
