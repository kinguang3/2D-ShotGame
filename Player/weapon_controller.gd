extends Node2D
class_name WeaponController

var current_weapon: Weapon
var target_pos: Vector2



func equip_weapon(data: WeaponData) -> void:
	var weapon_scene = Global.all_weapon[data.weapon_name]
	
	var weapon:Weapon = weapon_scene.instantiate()
	weapon.global_position.y = -8
	current_weapon = weapon
	current_weapon.data = data#防止enemy的weapon使用的是玩家的weapon
	add_child(weapon)


	
	
func rotate_weapon() -> void:
	if not current_weapon:
		return
		
	current_weapon.pivot.look_at(target_pos)		#旋转该节点，使其局部 X 轴的正方向指向 point，该参数应使用全局坐标。该方法是 rotate() 和 get_angle_to() 的结合。
