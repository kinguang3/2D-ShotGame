extends Control


class_name DiscriptionPanel

@onready var label: Label = $NinePatchRect/Label


func set_text(value:String) -> void:
	label.text = value
