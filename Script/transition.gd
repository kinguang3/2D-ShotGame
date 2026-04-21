extends Node

@onready var effect: ColorRect = %Effect

func traansition_to(scene_path: String) -> void:
	var tween = create_tween()
	tween.tween_property(effect.material,"shader_parameter/radius",1,1)
	
	
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
	
	
	tween = create_tween()
	tween.tween_property(effect.material,"shader_parameter/radius",0,1)


func show_transition_in() -> Tween:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(effect.material,"shader_parameter/radius",1,1)
	return tween
	
func show_transition_out() -> Tween:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(effect.material,"shader_parameter/radius",0,1)
	return tween
