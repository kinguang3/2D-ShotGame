extends CanvasLayer
@onready var sprite: Sprite2D = $Sprite2D



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta: float) -> void:
	sprite.position = get_viewport().get_mouse_position()
