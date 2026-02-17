extends Node2D

class_name HealthComponet
'''

生命组件的基本逻辑

'''
signal on_unit_damaged(amount:float)
signal on_unit_healed(amount:float)
signal on_unit_dead



var current_health: float
var max_health: float


func init_health(value:float) -> void:
	current_health=value
	max_health=value
	
func  take_damage(value:float) -> void:
	if current_health>0:
		current_health-=value
		on_unit_damaged.emit(value)
		if current_health<=0:
			die()
			
func die()->void:
	current_health=0.0
	on_unit_dead.emit()			
	
	
func  heal(value:float)->void:
	if 	current_health>max_health:
		return
	
	current_health=min(max_health,current_health+value)#防止超出最大血量
	on_unit_healed.emit(value)
	
	
	
