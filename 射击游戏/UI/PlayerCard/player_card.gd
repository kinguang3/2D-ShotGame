extends TextureButton

class_name PlayerCard

@onready var icon: TextureRect = $Icon

var data :PlayerData


func set_data(value:PlayerData) ->void:
	data = value
	icon.texture = data.icon
