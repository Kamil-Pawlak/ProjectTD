extends Control

func _on_pressed_play():
	var level_scene = preload("res://Main.tscn")
	get_tree().change_scene_to_packed(level_scene)
	
func _on_pressed_exit():
	get_tree().quit()
