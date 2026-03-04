extends Node2D
class_name WeaponController

var current_weapon: Weapon
var target_pos: Vector2




func _process(delta: float) -> void:
	target_pos = get_global_mouse_position()#得到鼠标的全局位置
	rotate_weapon()

func equip_weapon() -> void:
	var weapon:Weapon = Global.get_weapon().instantiate()
	weapon.global_position.y = -8
	current_weapon = weapon
	current_weapon.data = Global.selected_weapon
	add_child(weapon)


	
	
func rotate_weapon() -> void:
	if not current_weapon:
		return
		
	current_weapon.pivot.look_at(target_pos)		#旋转该节点，使其局部 X 轴的正方向指向 point，该参数应使用全局坐标。该方法是 rotate() 和 get_angle_to() 的结合。
