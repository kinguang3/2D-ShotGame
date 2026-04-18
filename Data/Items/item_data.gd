extends Resource
class_name ItemData

@export var icon :Texture2D
@export var id :String
@export var name: String
@export var value: float
@export var price : float
@export_enum("Common","Rare","Epic") var rarity = "Common"
@export_multiline var description: String#这样就能够支持编辑多行内容，便于在编辑属性中存储大量文本。
