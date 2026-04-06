extends CharacterBody2D
class_name Enemy



@export var max_health = 5.0
@export var collision_damage = 2.0
@export var dead_texture:Texture2D
@export_group("Enemy Chase")#export_group是将导出变量分组,chase是追踪
@export var chase_speed = 40
@export_group("Enemy Weapon")
@export var move_speed = 40
@export var weapon:WeaponData

@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_componet: HealthComponet = $HealthComponet


var can_move:bool = true
var is_killed:bool
func _ready() -> void:
	health_bar.value = 1
	health_componet.init_health(max_health)

func _physics_process(delta: float) -> void:
	if not Global.player_ref:return
	if not can_move : return
	
	var dir=global_position.direction_to(Global.player_ref.global_position)#返回从该向量指向 to 的归一化向量。
	velocity = dir * chase_speed
	move_and_slide()

func rotate_enemy() -> void:
	if global_position.x > Global.player_ref.global_position.x:
		anim_sprite.flip_h = true
	if global_position.x < Global.player_ref.global_position.x:
		anim_sprite.flip_h = false

func enemy_dead() -> void:
	Global.create_dead_particle(dead_texture,global_position)
	EventBus.on_enemy_die.emit()
	queue_free()


func _on_player_detector_body_entered(body: Node2D) -> void:
	enemy_dead()
	


func _on_health_componet_on_unit_damaged(amount: float) -> void:
	health_bar.value = health_componet.current_health / max_health
	anim_sprite.material = Global.HIT_MATERIAL
	await get_tree().create_timer(0.15).timeout
	anim_sprite.material = null

func _on_health_componet_on_unit_dead() -> void:
	enemy_dead()
