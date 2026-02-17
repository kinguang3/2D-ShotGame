extends Node

var save_path = "user://save.json"#保存在用户电脑中的存储数据


var settings: Dictionary = {
	"music" = true,
	"sfx"= true,
	"fullscreen" = true
}


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
