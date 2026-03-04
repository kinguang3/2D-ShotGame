extends Control
class_name Mainmenu

@export var menu_cursor: Texture2D
@onready var main_buttons: Control = $MainButtons
@onready var settings_buttons: Control = $SettingsButtons
@onready var ui_sound: AudioStreamPlayer = $UISound
@onready var music_label: Label = %MusicLabel
@onready var sfx_label: Label = %SFXLabel
@onready var window_label: Label = $SettingsButtons/VBoxContainer/Window/WindowButton/WindowLabel
@onready var hover_sound: AudioStreamPlayer = $HoverSound


func _ready() -> void:
	Cursor.sprite.texture = menu_cursor
	update_audio_bus("Music",music_label,Global.settings.music)#使指定的音乐线mute（静音）
	update_audio_bus("SFX",sfx_label,Global.settings.sfx)#使指定的音乐线mute（静音）
	update_fullscreen(Global.settings.fullscreen)


func update_audio_bus(bus_name: String,label: Label,is_on: bool) -> void:#更新music和sfx
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name),not is_on)#使指定的音乐线mute（静音）
	label.text = "%s:%s" % [bus_name,"ON" if is_on else "OFF"]#格式化输出
	

func update_fullscreen(is_on: bool) -> void:#更新全屏模式
	var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if is_on else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	window_label.text = "FULLSCREEN" if is_on else "WINDOWED"



func _on_play_button_pressed() -> void:
	ui_sound.play()
	Transition.traansition_to("res://UI/CharacterSelection/character_selections.tscn")
	pass # Replace with function body.



func _on_settings_button_pressed() -> void:
	ui_sound.play()
	var tween = create_tween()
	tween.tween_property(main_buttons,"global_position:y",350,0.2)
	tween.tween_interval(0.1)#tween动画时间的间隔
	tween.tween_property(settings_buttons,"global_position:x",145,0.3)
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	ui_sound.play()
	Global.save_data()#退出游戏时存储数据
	get_tree().quit()


func _on_music_button_pressed() -> void:
	ui_sound.play()
	Global.settings.music = not Global.settings.music
	update_audio_bus("Music",music_label,Global.settings.music)#使指定的音乐线mute（静音）
	pass # Replace with function body.


func _on_sfx_button_pressed() -> void:
	ui_sound.play()
	Global.settings.sfx = not Global.settings.sfx
	update_audio_bus("SFX",sfx_label,Global.settings.sfx)#使指定的音乐线mute（静音）
	#false默认为不静音
	pass # Replace with function body.


func _on_window_button_pressed() -> void:
	ui_sound.play()
	Global.settings.fullscreen = not Global.settings.fullscreen
	update_fullscreen(Global.settings.fullscreen)


func _on_back_button_pressed() -> void:
	ui_sound.play()
	var tween = create_tween()#创建补间动画
	tween.tween_property(settings_buttons,"global_position:x",558,0.2)
	tween.tween_interval(0.1)#tween动画时间的间隔
	tween.tween_property(main_buttons,"global_position:y",115,0.3)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	hover_sound.play()



func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_data()
		
