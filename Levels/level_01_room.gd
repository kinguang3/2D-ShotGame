extends Node2D
class_name LevelRoom
#标记后续属性会在 Node 就绪时赋值
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var tile_data: TileMapLayer = $TileData



@onready var room_wall:Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP : %WallUP,
	Vector2i.RIGHT : %WallRight,
	Vector2i.DOWN : %WallDown,
	Vector2i.LEFT : %WallLeft
}

@onready var clear_door_nodes:Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP :%DoorUP ,
	Vector2i.RIGHT :%DoorRight,
	Vector2i.DOWN : %DoorDown,
	Vector2i.LEFT : %DoorLeft
}


var tiles:Array[Vector2i]
var is_cleared:bool#检测玩家是否把敌人清理完毕


func _ready() -> void:
	close_all_walls()#先关闭所有的门，再根据连接依次打开
	register_tiles()#Tiled地图编辑器中的自定义属性，映射到游戏中的具体组件或功能上

func register_tiles() -> void:
	for tile in tile_data.get_used_cells():#返回 Vector2i 数组，其中存放的是所有包含图块的单元格的位置
		tiles.append(tile)#存入数组
	

func lock_room() -> void:
	for direction in clear_door_nodes:
		var wall_door = room_wall[direction]
		var clear_door = clear_door_nodes[direction]
		if wall_door and not wall_door.enabled:
			clear_door.enabled = true

func unlock_door() -> void:
	for direction in clear_door_nodes:
		clear_door_nodes[direction].enabled = false
	


func open_walls(direction:Vector2i) -> void:
	if room_wall.has(direction):#has:如果该字典包含给定的键 key，则返回 true。
		room_wall[direction].enabled = false
	#做安全判断

func close_all_walls() -> void:
	for key in room_wall:
		room_wall[key].enabled = true


func _on_player_detector_body_entered(body: Node2D) -> void:
	EventBus.on_player_room_entered.emit(self)
