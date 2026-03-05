extends Node2D

class_name Arena


@export var arena_cursor:Texture2D
@export var level_data:LevelData


@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar

var grid:Dictionary[Vector2i,LevelRoom] = {}#Vector2i:使用整数坐标的 2D 向量。
#Vector2i代表房间坐标,用levelroom连接每一个坐标

var start_room_coord:Vector2i
var end_room_coord:Vector2i



func _ready() -> void:
	Cursor.sprite.texture = arena_cursor
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	generate_level_layout()
	select_special_rooms()
	
	
	load_game_selection()

func generate_level_layout() -> void:
	grid.clear()#清除字典,防止报错
	print("Creating Layout...")#测试
	var current_coord = Vector2i.ZERO#初始化出生点房间坐标为(0,0)
	grid[current_coord] = null#初始房间没有连接
	var directions = [Vector2i.UP,Vector2i.DOWN,Vector2i.RIGHT,Vector2i.LEFT]
	#创建上下左右四个方向,返回数值是1，-1
	while grid.size() < level_data.num_rooms:
		if randf() > 0.5:#返回 0.0 和 1.0（包含）之间的随机浮点值,就是随机数值来代表随机房间
			current_coord = grid.keys().pick_random()#随机选择房间坐标

		var random_direction = directions.pick_random()#随机选择
		var next_coord = current_coord + random_direction
		
		var attempts = 0#随机选择次数
		while grid.has(next_coord) and attempts < 10:
			random_direction = directions.pick_random()
			next_coord = current_coord + random_direction
			attempts+=1
		if not grid.has(next_coord):#执行到这里说明还没有创建房间
			grid[next_coord] = null
	for key:Vector2i in grid.keys():
		print(key)

func select_special_rooms() -> void:
	pass

	
func load_game_selection() -> void:
	var player:Player = Global.get_player().instantiate()
	add_child(player)
	player.weapon_controller.equip_weapon()

func  _on_player_health_updated(current:float,max:float) -> void:
	health_bar.value = current / max #保持相对比例
	
