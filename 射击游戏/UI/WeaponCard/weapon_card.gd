extends TextureButton



class_name WeaponCard
@onready var icon: TextureRect = $Icon
var data : WeaponData


func set_data(value:WeaponData) -> void:
	data = value
	icon.texture = data.icon
