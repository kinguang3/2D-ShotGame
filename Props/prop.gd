extends Area2D
class_name Prop
@onready var sprite: Sprite2D = $Sprite2D


func _on_body_entered(body: Node2D) -> void:
	DampedOscillator.animate(sprite,"scale",250,10,17,0.5 * randi_range(0,1))
