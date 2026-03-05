extends Control
class_name DamageText


@onready var label: Label = $Label

 

func setup(value:float) -> void:
	label.text = str(value) #数字转换为字符串
	await get_tree().create_timer(0.5).timeout #可以在主程序中创建冷却时间
	queue_free()
