extends CharacterBody2D
class_name Enemy

@export_enum("Chase","Weapon") var enemy_type = "Chase"#用作枚举选项列表（或选项的数组）。如果属性为 int，则存储的是值的索引，与值的顺序相同。你可以使用冒号来显式添加枚举项的取值。如果属性为 String，则存储的是值。
#默认是Chase
enum EnemyState {
	FINDING_DESTINATION,
	MOVING,
	ATTACKING
}#创建枚举状态


@export var max_health = 5.0
@export var collision_damage = 2.0
@export var dead_texture:Texture2D
@export_group("Enemy Chase")#export_group是将导出变量分组,chase是追踪
@export var chase_speed = 60
@export_group("Enemy Weapon")
@export var move_speed = 40
@export var weapon:WeaponData#保证武器名字一样，不然访问不到

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_componet: HealthComponet = $HealthComponet
@onready var enemy_dectector: Area2D = $EnemyDectector
@onready var weapon_controller: WeaponController = $WeaponController#用weapon添加判定


var can_move:bool = true
var is_killed:bool
var cooldown:float
var parent_room:LevelRoom#获取enemy在当前房间的引用
var enemy_state:EnemyState
var move_destination :Vector2

func _ready() -> void:
	health_bar.value = 1
	health_componet.init_health(max_health)
	
	if not weapon :return
	weapon_controller.equip_weapon(weapon)#这里的weapon是自己指定的weapon


func _process(delta: float) -> void:
	if not Global.player_ref:return
	rotate_enemy()#在我看来在这里添加rotate_enemy是为了防止bug(在_physics_process里面有rotate_enemy)
	if enemy_state == EnemyState.ATTACKING:
		manage_weapon(delta)
	


func _physics_process(_delta: float) -> void:
	if not Global.player_ref:return
	if not can_move : return
	
	match enemy_type:#export定义的两个大状态
		"Chase":
			run_enemy_chase()
		"Weapon":#因为enum没有weapon这个状态,所以在run_enemy_weapon()函数里面写match
			run_enemy_weapon()

func run_enemy_chase() -> void:#emey的chase逻辑
	var dir=global_position.direction_to(Global.player_ref.global_position)#返回从该向量指向 to 的归一化向量。
	for enemy :Enemy in enemy_dectector.get_overlapping_bodies():#返回相交的 PhysicsBody2D 和 TileMap,接触到的body
		if enemy != self and enemy.is_inside_tree():#如果该节点当前在 SceneTree 中，返回 true
			var vector = global_position - enemy.global_position#每个敌人之间的方向坐标
			dir += 10 * vector.normalized() / vector.length()#防止enemy之间的位置出现重置
			
		
	velocity = dir * chase_speed
	move_and_slide()


func run_enemy_weapon() -> void:
	match enemy_state:
		EnemyState.FINDING_DESTINATION:
			var local_pos = parent_room.get_free_spawn_position()
			move_destination = parent_room.to_global(local_pos)#局部位置要转换为全局位置,要是当前位置parent_room
			enemy_state = EnemyState.MOVING#切换状态
			
		EnemyState.MOVING:
			var dir = global_position.direction_to(move_destination)#返回从该向量指向 to 的归一化向量。(从当前位置到to的方向)
			velocity = dir * move_speed
			move_and_slide()
			if global_position.distance_to(move_destination) < 2.0:#distance是距离
				velocity = Vector2.ZERO
				enemy_state = EnemyState.ATTACKING
				
		EnemyState.ATTACKING:
			velocity = Vector2.ZERO#保险起见
			move_and_slide()
			await get_tree().create_timer(1.0).timeout
			enemy_state = EnemyState.FINDING_DESTINATION

func manage_weapon(delta: float) -> void:
	if not weapon:return
	if not weapon_controller:return
	weapon_controller.target_pos = Global.player_ref.global_position
	weapon_controller.rotate_weapon()
	
	cooldown -= delta
	if cooldown <= 0:
		weapon_controller.current_weapon.use_weapon()
		cooldown = weapon_controller.current_weapon.data.cooldown



func rotate_enemy() -> void:
	if global_position.x > Global.player_ref.global_position.x:
		anim_sprite.flip_h = true
	if global_position.x < Global.player_ref.global_position.x:
		anim_sprite.flip_h = false

func enemy_dead() -> void:
	if is_killed:
		return
	
	is_killed = true
	Global.create_dead_particle(dead_texture,global_position)
	EventBus.on_enemy_die.emit()
	queue_free()


func _on_player_detector_body_entered(body: Node2D) -> void:
	body.health_componet.take_damage(collision_damage)
	enemy_dead()
	


func _on_health_componet_on_unit_damaged(amount: float) -> void:
	health_bar.value = health_componet.current_health / max_health
	anim_sprite.material = Global.HIT_MATERIAL
	anim_sprite.play("hurt")
	await get_tree().create_timer(0.15).timeout
	anim_sprite.material = null
	anim_sprite.play("move")

func _on_health_componet_on_unit_dead() -> void:
	enemy_dead()
