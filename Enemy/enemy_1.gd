extends CharacterBody2D
class_name Enemy


@onready var anim_sprite: AnimatedSprite2D = $AnimSprite
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound


var can_move:bool = true


func _physics_process(delta: float) -> void:
	if not Global.player_ref:return
	if not can_move : return
	
	var dir=global_position.direction_to(Global.player_ref.global_position)#返回从该向量指向 to 的归一化向量。
	velocity = dir * 50.0
	move_and_slide()

func rotate_enemy() -> void:
	if global_position.x > Global.player_ref.global_position.x:
		anim_sprite.flip_h = true
	if global_position.x < Global.player_ref.global_position.x:
		anim_sprite.flip_h = false


func _on_player_detector_body_entered(body: Node2D) -> void:
	anim_sprite.play("die")
	await anim_sprite.animation_finished
	EventBus.on_enemy_die.emit()
	queue_free()
	
