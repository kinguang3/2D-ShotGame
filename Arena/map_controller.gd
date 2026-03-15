extends Control
class_name MapController

const MAP_CELL_SCENE = preload("uid://cmphgec3ss4ks")


var minimap_cells:Dictionary[Vector2i,MapCell] = {}
var player_coord:Vector2i = Vector2i.MAX# MAX = Vector2i(2147483647, 2147483647)
#填充整个minicell
var cell_size:Vector2#对于大小可能有小数
#对于坐标只能用整数
func update_on_room_entered(new_room_coord:Vector2i) -> void:
	if new_room_coord == player_coord:
		return
	
	if minimap_cells.has(player_coord):
		minimap_cells[player_coord].set_player_active(false)	

	var new_cell:MapCell
	if minimap_cells.has(new_room_coord):
		new_cell = minimap_cells[new_room_coord]#如果字典中有该房间的单元格，就返回该单元格
	else:
		new_cell = create_map_cell(new_room_coord)#如果没有该房间的单元格，就创造单元格

	player_coord = new_room_coord
	new_cell.set_player_active(true)



func create_map_cell(coord:Vector2i) -> MapCell:
	var new_cell:MapCell = MAP_CELL_SCENE.instantiate()
	minimap_cells[coord] = new_cell#小地图中添加新的单元格
	add_child(new_cell)
	
	if cell_size == Vector2.ZERO:
		cell_size = new_cell.size#第一次创建单元格,初始化大小
	var relative_pos = Vector2(coord.x * cell_size.x,coord.y * cell_size.y)
	new_cell.position = (size/2.0) + relative_pos - (cell_size/2.0)
	#size代表mapcontroller的大小
	return new_cell

func reset() -> void:
	for cell:MapCell in minimap_cells.values():
		cell.queue_free()
	minimap_cells.clear()
	player_coord = Vector2i.MAX
	cell_size = Vector2.ZERO
