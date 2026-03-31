extends Node2D
class_name EnemySpawner

var enemies:Array[Enemy] = []
var enemies_killed:int


func _ready() -> void:
	EventBus.on_enemy_die.connect(_on_enemy_die)
	

func spawn_enemies(data:LevelData,room:LevelRoom) -> void:
	if data.enemy_scene.is_empty():
		return

	await get_tree().create_timer(0.5).timeout
	var amount = randf_range(data.min_enemies_per_room,data.max_enemies_per_room)
	for i in amount:
		var randow_scene = data.enemy_scene.pick_random()
		var enemy:Enemy = randow_scene.instantiate()
		enemies.append(enemy)
		get_parent().add_child(enemy)
		var spawn_local_pos = room.get_free_spawn_position()
		var spawn_global_pos = room.to_global(spawn_local_pos)
		enemy.global_position = spawn_global_pos


func _on_enemy_die() -> void:
	enemies_killed += 1
	if enemies_killed >= enemies.size():
		EventBus.on_room_cleared.emit()
		enemies.clear()
		enemies_killed = 0
