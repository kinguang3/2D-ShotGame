extends Node2D#远程武器已经定义为node2d了，则继承自远程武器
class_name Weapon

'''
为所有武器的基本逻辑写的脚本（远程和近战）
有瞄准点，攻击(shoot)等等
'''
@export var data: WeaponData
@onready var pivot: Node2D = $Pivot


func use_weapon() -> void:
	pass
