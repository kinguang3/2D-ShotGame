extends Node2D

class_name Arena


@export var arena_cursor:Texture2D

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar


func _ready() -> void:
	Cursor.sprite.texture = arena_cursor
	EventBus.on_player_health_updated.connect(_on_player_health_updated)



func  _on_player_health_updated(current:float,max:float) -> void:
	health_bar.value = current / max   #保持相对比例
	
