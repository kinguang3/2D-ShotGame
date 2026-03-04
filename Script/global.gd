extends Node

var save_path = "user://save.json"#保存在用户电脑中的存储数据

var settings: Dictionary = {
	"music" = true,
	"sfx"= true,
	"fullscreen" = true
}

const EXPLOSION_EFFECTS_SCEEN = preload("uid://nriecmsctdr7")
const DAMAGE_TEXT_SCENE = preload("uid://b8qwyqx8djwvi")




var all_player: Dictionary[String,PackedScene]={
	"Bunny":preload("uid://udnu8n7kvque"),
	"Dog":preload("uid://bgk8an0d1nvcj"),
	"Cat":preload("uid://ce5354e2aq8s2"),
	"Mouse":preload("uid://bjomv30qd45e5")
	
}

var all_weapon: Dictionary[String,PackedScene]={
	"AK47":preload("uid://bvoie0j8aeayr"),
	"Pistol":preload("uid://cex6jxc7xa8lb"),
	"Mac10":preload("uid://dyhjf0lqlev6c"),
	"Mp5":preload("uid://bbhsgwtjno46b"),
	"Shotgun":preload("uid://d0ei6cs3kkd5g"),
	"Sniper":preload("uid://dvv03lwuw7d3t"),
	"Uzi":preload("uid://cex3ebw46f8jn"),
	"Sword":preload("uid://bqd8vk7waug5x"),
	"Axe":preload("uid://d13j4d2whceb0")
}


var selected_player :PlayerData
var selected_weapon :WeaponData


func _ready() -> void:
	load_data()#游戏开始时读取数据,只读取一次

func get_player() -> PackedScene:
	return all_player[selected_player.id]

func get_weapon() -> PackedScene:
	return all_weapon[selected_weapon.weapon_name]


func creat_explosion(pos:Vector2) ->void:
	var explosion:Node2D = EXPLOSION_EFFECTS_SCEEN.instantiate()
	explosion.global_position = pos
	get_tree().root.add_child(explosion)



func create_damage_text(value:float,pos:Vector2) -> void:
	var damage:DamageText = DAMAGE_TEXT_SCENE.instantiate()
	get_parent().add_child(damage)#返回该节点的父节点，如果该节点没有父节点，则返回 null。
	var random_pos = randf_range(0,TAU)#圆常量，单位圆的周长，单位为弧度。相当于 PI * 2，即 360 度旋转
	damage.global_position = pos + Vector2.RIGHT.rotated(random_pos) * 20#范围更大
	damage.setup(value)
	pass

func save_data() -> void:#存储数据的格式
	var save = settings.duplicate()#返回字典的新副本。
	
	var file = FileAccess.open(save_path,FileAccess.WRITE)#将数据保存在文件中，写入模式
	var json_string = JSON.stringify(save)#将数据转换成json格式、
	file.store_string(json_string)#将 string 存储到文件中，不带换行符（\n）
	file.close()#关闭文件


func load_data() -> void:#读取数据的基本格式
	if not FileAccess.file_exists(save_path):#判断文件中是否有数据
		return
	
	var file = FileAccess.open(save_path,FileAccess.READ)
	var json = file.get_as_text()#获取json
	var data = JSON.parse_string(json)
	file.close()
	
	settings = data
