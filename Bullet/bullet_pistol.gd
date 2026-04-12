extends Area2D

class_name Bullet


var data :WeaponData


func setup(data:WeaponData) -> void:
	self.data = data
	

func _process(delta: float) -> void:
	if not data: return
	move_local_x(data.bullet_speed * delta) #用旋转来代替y方向上的坐标
	

func _on_body_entered(body: Node2D) -> void:
	Global.creat_explosion(global_position) #子弹的位置
	if body is Enemy or body is Player:#防止enemy的bullet没有下面的逻辑
		Global.create_damage_text(data.damage,body.global_position) #显示伤害
		body.health_componet.take_damage(data.damage)#因为body是enemy所以有自动补全
		
	queue_free()
	
