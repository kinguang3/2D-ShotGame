extends Weapon
class_name WeaponMelee

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var slash: GPUParticles2D = %SlashParticle
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var slash_sound: AudioStreamPlayer = $SlashSound
@onready var cooldown: Timer = $Cooldown

var can_use :bool=true

var entities:Array[Node2D]

func use_weapon() -> void:
	if not can_use:
		return
	
	can_use = false
	cooldown.start()
	anim_player.play("slash") #开始挥砍
	slash_sound.play() #播放音效
	
	for enemy: Node2D in entities:
		Global.create_damage_text(data.damage,enemy.global_position)
	slash.global_rotation = pivot.global_rotation
	slash.emitting = true #展示粒子效果
	await anim_player.animation_finished
	anim_player.play("back")
	await anim_player.animation_finished
	anim_player.play("idle")
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		use_weapon()

func _on_cooldown_timeout() -> void:
	can_use = true
	anim_player.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_instance_valid(body): #如果 instance 是有效的 Object（例如，没有从内存中删除），则返回 true
		entities.append(body)


func _on_hitbox_body_exited(body: Node2D) -> void:
	if is_instance_valid(body):
		entities.erase(body)
