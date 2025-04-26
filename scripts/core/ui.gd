extends CanvasLayer

func _on_basic_tower_button_pressed():
	var buildmode = $"../GameManager".build_mode
	if buildmode == false:
		$"../GameManager".start_build_mode(preload("res://scenes/towers/BasicTower.tscn"))
	else:
		$"../GameManager".stop_build_mode()
	buildmode = !buildmode
