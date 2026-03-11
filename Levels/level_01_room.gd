extends Node2D
class_name LevelRoom
#标记后续属性会在 Node 就绪时赋值
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var room_wall:Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP : %WallUP,
	Vector2i.RIGHT : %WallRight,
	Vector2i.DOWN : %WallDown,
	Vector2i.LEFT : %WallLeft
}


func _ready() -> void:
	close_all_walls()#先关闭所有的门，再根据连接依次打开


func open_walls(direction:Vector2i) -> void:
	if room_wall.has(direction):#has:如果该字典包含给定的键 key，则返回 true。
		room_wall[direction].enabled = false
	#做安全判断

func close_all_walls() -> void:
	for key in room_wall:
		room_wall[key].enabled = true
