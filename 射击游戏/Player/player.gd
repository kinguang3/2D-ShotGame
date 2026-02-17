extends CharacterBody2D
class_name Player

@export var data : PlayerData#用引号
@onready var visuals: Node2D = $Visuals
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D



var can_move = true
var movement : Vector2
var direction : Vector2


func _physics_process(delta: float) -> void:#平面角色的基本运动逻辑
	if not can_move:
		return
	direction = Input.get_vector("move_left","move_right","move_up","move_down")#通过指定正负 X 和 Y 轴的四个动作来获取输入向量。
	if direction != Vector2.ZERO:
		movement = direction * data.move_speed
		anim_sprite.play("move")#确保角色的动画存在且被定义
	else:
		movement = Vector2.ZERO
		anim_sprite.play("idle")	
	velocity = movement#velocity当前的速度向量，单位为像素每秒。该属性会在调用 move_and_slide() 时被使用和修改。
	move_and_slide()#根据 velocity 移动该物体。该物体如果与其他物体发生碰撞，则会沿着对方滑动（默认只在地板上滑动）
	rotate_player()



func rotate_player() -> void:
	if direction != Vector2.ZERO:
		if direction.x >= 0.1:
			visuals.scale=Vector2(1.0,1.0)#用visuals来定义角色动画的scale
		else:
			visuals.scale=Vector2(-1.0,1.0)	
	pass
	
	
	
	
	
	
	
	
	
