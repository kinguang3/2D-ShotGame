extends Node2D

class_name Arena


@export var arena_cursor:Texture2D
@export var levels:Array[LevelData]#创建不同房间的索引


@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar
@onready var map_controller: MapController = $UI/MapController
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var total_coins: Label = %TotalCoins
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var dungeon: Node2D = $Dungeon
@onready var level_title: Label = $UI/LevelTitle

var grid:Dictionary[Vector2i,LevelRoom] = {}#Vector2i:使用整数坐标的 2D 向量。
#Vector2i代表房间坐标,用levelroom连接每一个坐标

var start_room_coord:Vector2i#初始房间坐标
var end_room_coord:Vector2i#最远房间坐标
var grid_cell_size: Vector2i#创建最小房间单元(一个走廊+一个房间)
var current_room:LevelRoom
var player:Player
var store_room_coord:Vector2i
var current_level_index:int = 0 
var current_sub_level:int = 1
var level_data:LevelData

func _ready() -> void:
	Cursor.sprite.texture = arena_cursor
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	EventBus.on_player_room_entered.connect(_on_player_room_entered)
	EventBus.on_room_cleared.connect(_on_room_cleared)
	EventBus.on_coin_picked.connect(_on_coin_picked)
	EventBus.on_portal_reach.connect(_on_portal_reach)
	
	level_data = levels[0]
	generate_dungeon()
	
	
	await get_tree().create_timer(0.5).timeout
	show_level_title()


func _process(delta: float) -> void:
	total_coins.text = str(Global.coins)
	if is_instance_valid(Global.player_ref):
		mana_bar.value = Global.player_ref.current_mana / Global.player_ref.data.magic


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		current_room.unlock_room()
		current_room.is_cleared = true

func generate_dungeon() -> void:#在当前地牢里面创建房间和别的东西
	for child in dungeon.get_children():
		child.queue_free()
	
	await get_tree().process_frame#防止报错,等待一帧
	
	if player:
		player.queue_free()
		Global.player_ref = null#删除上一级地牢的所有东西
	
	map_controller.reset()
	for child in map_controller.get_children():
		child.queue_free()
	
	
	grid_cell_size = Vector2i(
		level_data.corridor_size.x+level_data.room_size.x,
		level_data.corridor_size.y+level_data.room_size.y
	)
	
	generate_level_layout()
	select_special_rooms()#保证先创建房间网格，再选择特殊房间,选完特殊房间后，创建房间
	create_rooms()#创建房间
	create_corridor()#创建完房间,再创建连接
	load_game_selection()
	
	var first_room = grid[Vector2i.ZERO]
	first_room.is_cleared = true#初始附房间不锁定



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


func create_rooms() -> void:
	print("Creating rooms...")
	for room_coord:Vector2i in grid.keys():
		var room_instance:LevelRoom = level_data.room_scene.instantiate()#实例化场景不受变量类型限制
		room_instance.position = room_coord * grid_cell_size#每一个房间场景的实例化在自己创建的坐标上
		#建立房间大小,用二维坐标乘于房间大小(最小单元房间大小)
		dungeon.add_child(room_instance)#添加为子节点
		room_instance.create_props(level_data)#通过当前房间的信息来创建环境
		grid[room_coord] = room_instance#实例化所有场景,将每一个coord和实例化场景连接
		
		if room_coord == store_room_coord:
			room_instance.is_cleared = true#如果是特殊房间，说明已经清空了
			room_instance.setup_room_as_shop(level_data)#设置shop_room
		
		if room_coord == end_room_coord:
			room_instance.is_cleared = true
			room_instance.setup_room_as_portal()
		
		
		connect_rooms(room_coord,room_instance)#用direction来连接所有房间
		
		#await get_tree().create_timer(0.5).timeout#创建时间看效果



func create_corridor() -> void:
	print("Create Corridor...")
	for room_coord:Vector2i in grid.keys():
		var room_instance:LevelRoom = grid[room_coord]#grid[room_coord]已经是实例化场景了
		#创建右连接
		var right_neighbor = room_coord + Vector2i.RIGHT
		if grid.has(right_neighbor):
			var corridor:Node2D = level_data.h_corridor.instantiate()
			#var room_pos = room_instance.position
			#var neighbor_pos = grid[right_neighbor].position
			corridor.position = room_instance.position + Vector2(
				grid_cell_size.x/2.0 , 0)#对于位置的坐标用vector2
			dungeon.add_child(corridor)
		#创建下连接
		var down_neighbor = room_coord + Vector2i.DOWN
		if grid.has(down_neighbor):
			var corridor:Node2D = level_data.v_corridor.instantiate()
			#var room_pos = room_instance.position
			#var neighbor_pos = grid[down_neighbor].position
			corridor.position = room_instance.position + Vector2(
				0 , grid_cell_size.y/2.0)#对于位置的坐标用vector2
			dungeon.add_child(corridor)#先添加在操作和后添加在操作应该是一样的
		
		
		
		
		
		

func connect_rooms(room_coord:Vector2i,room_instance:LevelRoom)->void:
	var directions = [Vector2i.UP,Vector2i.DOWN,Vector2i.RIGHT,Vector2i.LEFT]
	for direction in directions:
		var next_coord = room_coord + direction
		if grid.has(next_coord):
			room_instance.open_walls(direction)
		
		

func select_special_rooms() -> void:#初始换房间
	start_room_coord = Vector2i.ZERO#初始化房间的坐标为(0,0)
	end_room_coord = find_farthest_room()
	var candidate_coords = grid.keys()
	candidate_coords.erase(start_room_coord)#排除初始和结尾的房间
	candidate_coords.erase(end_room_coord)
	if not candidate_coords.is_empty():#防止非空
		store_room_coord = candidate_coords.pick_random()
	else:
		store_room_coord = Vector2i.MAX
		print("No shop coord")


func show_level_title() -> void:
	level_title.text = "%d-%d" % [current_level_index + 1,current_sub_level]
	level_title.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(level_title,"self_modulate",Color(1.0, 1.0, 1.0, 1.0),1)
	tween.tween_interval(1)
	tween.tween_property(level_title,"self_modulate",Color(1.0, 1.0, 1.0, 0.0),1)


func find_farthest_room() -> Vector2i:#最后的房间是坐标最远的房间
	var farthest_room_coord = start_room_coord #默认最后的房间是开始的房间
	var max_dist = 0.0 #开始最远距离为0 
	for room_coord:Vector2i in grid.keys():
		var dist = start_room_coord.distance_to(room_coord)
		if dist > max_dist:#找到最远距离
			max_dist = dist
			farthest_room_coord = room_coord
	return farthest_room_coord
	
func load_game_selection() -> void:
	player = Global.get_player().instantiate()#实例化玩家场景到地图中
	var first_room:LevelRoom = grid[Vector2i.ZERO]
	var spawn_pos:Marker2D = first_room.player_spawn_pos
	add_child(player)
	player.global_position = spawn_pos.global_position#全局位置
	player.weapon_controller.equip_weapon(Global.selected_weapon)#玩家的出生位置
	Global.player_ref = player

func find_coord_from_room(room:LevelRoom) -> Vector2i:
	for coord:Vector2i in grid:
		if grid[coord] == room:
			return coord
	return Vector2i.MAX


func  _on_player_health_updated(current:float,max:float) -> void:
	health_bar.value = current / max #保持相对比例
	

func _on_player_room_entered(room:LevelRoom) -> void:
	if room != current_room:
		current_room = room
		
		var absolute_pos = find_coord_from_room(room)
		var relative_pos = absolute_pos - start_room_coord
		map_controller.update_on_room_entered(relative_pos)
		
		
		if not room.is_cleared:
			room.lock_room()
			enemy_spawner.spawn_enemies(level_data,room)
			
			


func _on_room_cleared() -> void:
	current_room.unlock_room()
	current_room.is_cleared = true
	var tile_pos = current_room.get_free_spawn_position()#局部位置
	var chest_pos = current_room.to_global(tile_pos)#将提供的本地位置转换为全局坐标空间的位置
	var chest_instance :Chest= Global.CHEST_SCENE.instantiate()
	dungeon.call_deferred("add_child",chest_instance)#宝箱建议用call_deferred()
	chest_instance.global_position = chest_pos#创建宝箱位置
	


func _on_coin_picked() -> void:
	coin_sound.play()
	
	

func _on_portal_reach() -> void:
	await Transition.show_transition_in().finished
	
	if current_sub_level < level_data.num_sub_levels:
		current_sub_level += 1
		generate_dungeon()
	else:
		current_level_index += 1
		if current_level_index < levels.size():
			current_sub_level = 1
			level_data = levels[current_level_index]
			generate_dungeon()
		else:
			print("No more room")
			Transition.traansition_to("res://UI/mainmenu.tscn")
		
	await Transition.show_transition_out().finished
	show_level_title()
