extends Control


class_name CharacterSelection
const WEAPON_CARD_SCEEN = preload("uid://swhqu5qvut6h")
const PLAYER_CARD_SCEEN = preload("uid://ba5s0i6eiurqm")



@export var selection_cursor:Texture2D
@export var players:Array[PlayerData]
@export var weapons:Array[WeaponData]


@onready var play_container: HBoxContainer = $PlayContainer
@onready var weapon_container: HBoxContainer = $WeaponContainer
@onready var ui_sound: AudioStreamPlayer = $UISound
@onready var hover_sound: AudioStreamPlayer = $HoverSound


func _ready() -> void:
	Cursor.sprite.texture = selection_cursor
	load_selection_items()

func load_selection_items() ->void:
	for node in play_container.get_children():
		node.queue_free()
	for node in weapon_container.get_children():
		node.queue_free()	
	
	
	for data :PlayerData in players:#因为是场景，所以要实例化
		var card :PlayerCard = PLAYER_CARD_SCEEN.instantiate()#则会向本地场景提供本地场景资源。
		card.pressed.connect(_on_player_card_press.bind(data,card))#被绑定的参数在提供给 call() 的参数之后传递
		play_container.add_child(card)
		card.set_data(data)


	for data :WeaponData in weapons:
		var card :WeaponCard = WEAPON_CARD_SCEEN.instantiate()#则会向本地场景提供本地场景资源。
		card.pressed.connect(_on_weapon_card_press.bind(data,card))
		weapon_container.add_child(card)
		card.set_data(data)
	
	


func _on_play_button_pressed() -> void:
	if not Global.selected_player and not Global.selected_weapon:
		return
	ui_sound.play()
	Transition.traansition_to("res://Arena/arena.tscn")


func _on_back_button_pressed() -> void:
	ui_sound.play()
	Transition.traansition_to("res://UI/mainmenu.tscn")

func _on_player_card_press(data:PlayerData,selectcard:PlayerCard) -> void:
	ui_sound.play()
	Global.selected_player = data
	for card:PlayerCard in play_container.get_children():
		card.selector.hide()
	selectcard.selector.show()

func _on_weapon_card_press(data:WeaponData,selectcard:WeaponCard) -> void:
	ui_sound.play()
	Global.selected_weapon = data
	for card:WeaponCard in weapon_container.get_children():
		card.selector.hide()
	selectcard.selector.show()


func _on_play_button_mouse_entered() -> void:
	hover_sound.play()


func _on_back_button_mouse_entered() -> void:
	hover_sound.play()
