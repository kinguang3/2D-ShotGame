extends Resource
class_name LevelData

@export var num_sub_levels:=4
@export var num_rooms:=10
@export var room_size:=Vector2i(384, 416)
@export var room_scene:PackedScene
@export var h_corridor:PackedScene
@export var v_corridor:PackedScene
@export var corridor_size:=Vector2i(192, 150)#x方向用于水平走廊，y方向用于垂直走廊
@export var min_enemies_per_room:=5
@export var max_enemies_per_room:=10
@export var max_props_per_room = 5
@export var props:Array[PackedScene]
@export var enemy_scene:Array[PackedScene]
@export var store_data:Array[LevelStoreData]#创建商店的物品数据


func get_random_store_item() -> ItemData:
	var rng = RandomNumberGenerator.new()#提供生成伪随机数的方法。
	rng.randomize()#为这个 RandomNumberGenerator 实例设置基于时间的种子
	
	var weights:PackedFloat32Array = []#存入随机值
	for data in store_data:
		weights.append(data.item_prob)#通过prob数值来获取索引（我个人认为）
	
	var index = rng.rand_weighted(weights)#返回具有非均匀权重的随机索引。如果数组为空，则输出错误并返回 -1。
	#下标的随机索引
	return store_data[index].item_data
	
