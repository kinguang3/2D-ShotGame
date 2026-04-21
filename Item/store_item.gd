extends Area2D
class_name  StoreItem

@export var commen_glow:Color
@export var rare_glow:Color
@export var epic_glow:Color


@onready var sprite: Sprite2D = $Sprite
@onready var glow: Sprite2D = $Glow
@onready var price: RichTextLabel = $Price
@onready var description_panel: DiscriptionPanel = $DescriptionPanel

var data:ItemData
var can_buy_item:bool

func setup(item_data:ItemData) -> void:
	data = item_data#保证当前物品的数据和创建的数据相同
	sprite.texture = data.icon
	glow.self_modulate = glow_rarity_color()#应用于这个 CanvasItem 的颜色
	price.text = "[code][img=10]Assets/Sprites/coin.png[/img][/code] %s" % data.price
	description_panel.set_text(data.description)


func buy_item() -> void:
	if not data:return
	if Global.coins < data.price:return
	match data.id:
		"Potion":#药品的id就是Potion
			Global.player_ref.health_componet.heal(data.value)
		"Mana":#药品的id就是Mana
			Global.player_ref.current_mana += data.value
		"ManaBoost":
			Global.player_ref.data.magic += data.value
		"SpeedBoost":
			Global.player_ref.data.move_speed += data.value
	
	
	Global.coins -= data.price
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_buy_item:
		buy_item()

func glow_rarity_color() -> Color:
	match data.rarity:
		"Common":
			return commen_glow
		"Rare":
			return rare_glow
		"Epic":
			return epic_glow
	return Color.WHITE


func _on_body_entered(body: Node2D) -> void:
	can_buy_item = true
	description_panel.show()
	DampedOscillator.animate(description_panel,"scale",randf_range(400,450),randf_range(5,10),randf_range(10,15),0.5)
	DampedOscillator.animate(description_panel,"rotation_degrees",300,7.5,15,randf_range(-20,20)*0.5)


func _on_body_exited(body: Node2D) -> void:
	can_buy_item = false
	description_panel.hide()
