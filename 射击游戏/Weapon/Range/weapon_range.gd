extends Weapon
class_name WeaponRange
@onready var sprite: Sprite2D = %Sprite2D

var directions: Vector2
func _process(delta: float) -> void:
	rotate_weapon()


func use_weapon() -> void:
	pass



func rotate_weapon() -> void:
	directions = get_global_mouse_position()-global_position
	sprite.flip_v=directions.x < 0
