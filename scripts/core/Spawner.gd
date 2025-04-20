extends Node2D

@export var enemy_scene = preload("res://scenes/enemies/Enemy.tscn")
@onready var path: Path2D = $"../Path2D"

func get_path_start_position() -> Vector2:
	return path.curve.get_point_position(0)

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var path_follow = PathFollow2D.new()
	enemy.global_position = get_path_start_position()
	path.add_child(path_follow)

	# Assign the follow reference
	enemy.path_follow = path_follow

	# Add the enemy to the scene
	get_tree().current_scene.add_child(enemy)

func _on_timer_timeout():
	spawn_enemy()
