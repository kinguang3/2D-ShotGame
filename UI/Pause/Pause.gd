extends CanvasLayer


@export var area_cursor:Texture2D
@export var pause_cursor:Texture2D
@onready var pause_panel: Panel = $Pause/PausePanel

func _process(delta: float) -> void:
	var volume_linear = db_to_linear(Music.volume_db)#从线性能量转换为分贝（音频）
	var target_volume =  0.0 if get_tree().paused else 1.0
	volume_linear = lerp(volume_linear, target_volume, delta * 0.15)
	Music.volume_db = linear_to_db(volume_linear)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and get_tree().paused:
		pause_panel.visible = false
		unpause()
	elif event.is_action_pressed("esc") and not get_tree().paused:
		pause_panel.visible = true
		pause()


func pause() -> void:
	Cursor.sprite.texture = pause_cursor
	get_tree().paused = true


func unpause() -> void:
	Cursor.sprite.texture = area_cursor
	get_tree().paused = false
	pause_panel.visible = false


func backmain() -> void:
	get_tree().paused = false
	pause_panel.visible = false
	Transition.traansition_to("res://UI/mainmenu.tscn")
	


func quit() -> void:
	Global.save_data()
	get_tree().quit()
