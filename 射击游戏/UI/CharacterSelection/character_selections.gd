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
		play_container.add_child(card)
		card.set_data(data)


	for data :WeaponData in weapons:
		var card :WeaponCard = WEAPON_CARD_SCEEN.instantiate()#则会向本地场景提供本地场景资源。
		weapon_container.add_child(card)
		card.set_data(data)
	
	


func _on_play_button_pressed() -> void:
	ui_sound.play()
	Transition.traansition_to("res://Arena/arena.tscn")


func _on_back_button_pressed() -> void:
	ui_sound.play()
	Transition.traansition_to("res://UI/mainmenu.tscn")
