extends Area2D
class_name Coin


func _on_body_entered(body: Node2D) -> void:
	Global.coins += 1
	EventBus.on_coin_picked.emit()
	queue_free()
