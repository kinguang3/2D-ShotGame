extends TextureButton



class_name WeaponCard
@onready var icon: TextureRect = $Icon
var data : WeaponData
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var selector: TextureRect = $Selector
@onready var description_panel: DiscriptionPanel = $DescriptionPanel


func set_data(value:WeaponData) -> void:
	data = value
	icon.texture = data.icon
	set_description()

func set_description() -> void:
	var string = "Weapon: %s\n" % data.weapon_name
	string+="Damage: %.1f\nCooldown: %.1f\nMCost: %.1f" %[data.damage,data.cooldown,data.mana_cost]
	description_panel.set_text(string)

func _on_mouse_entered() -> void:
	hover_sound.play()
	DampedOscillator.animate(icon,"scale",randf_range(400,450),randf_range(5,10),randf_range(10,15),0.5)
	description_panel.show()
	DampedOscillator.animate(description_panel,"scale",randf_range(400,450),randf_range(5,10),randf_range(10,15),0.5)
	DampedOscillator.animate(description_panel,"rotation_degrees",300,7.5,15,0.5*randf_range(-20,20))

func _on_mouse_exited() -> void:
	description_panel.hide()
