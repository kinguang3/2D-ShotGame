extends StaticBody2D
class_name Chest

const COINS_SCENE = preload("uid://d3aidbksfhmue")


@export var coin_amount = 5

@onready var chest_close: Sprite2D = $ChestClose
@onready var chest_open: Sprite2D = $ChestOpen
@onready var chest_sound: AudioStreamPlayer = $ChestSound
@onready var drop_position: Marker2D = $DropPosition


var collected :bool#避免重复打开宝箱



func _on_area_2d_body_entered(body: Node2D) -> void:#交互功能的初步实现
	if collected:return
	
	chest_close.hide()
	chest_open.show()
	chest_sound.play()
	for i in coin_amount:
		var coin = COINS_SCENE.instantiate() as Coin
		get_tree().root.call_deferred("add_child",coin)#在空闲时调用该对象的 method 方法。始终返回 null，不返回该方法的结果
		var pos = drop_position.global_position#获取金币掉落位置
		coin.global_position = Vector2(randf_range(pos.x-30,pos.x+30),pos.y)#Vector里面也能添加randf_range获取随机位置
		
	collected = true
