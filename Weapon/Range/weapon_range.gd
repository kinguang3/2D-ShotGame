extends Weapon
class_name WeaponRange
@onready var sprite: Sprite2D = %Sprite2D
@onready var fire_pos: Marker2D = %FirePos

var directions: Vector2
var cooldown :float
func _process(delta: float) -> void:
	rotate_weapon()
	
	cooldown -= delta
	if Input.is_action_pressed("shoot"):
		if cooldown <= 0:
			use_weapon()
			cooldown = data.cooldown
	

func use_weapon() -> void:
	var bullet:Bullet = data.bullet_scene.instantiate()
	bullet.setup(data)
	bullet.global_position = fire_pos.global_position #继承武器标记的位置
	bullet.global_rotation = pivot.global_rotation + deg_to_rad(randf_range(-data.spread,data.spread)) #继承武器的旋转属性并添加随机值
	get_tree().root.add_child(bullet)

func rotate_weapon() -> void:
	directions = get_global_mouse_position()-global_position
	sprite.flip_v=directions.x < 0
