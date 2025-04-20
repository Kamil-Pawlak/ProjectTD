extends Node2D

@export var enemy_scene = preload("res://scenes/enemies/Enemy.tscn")
@onready var path = $"../Path2D"

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var path_follow = PathFollow2D.new()
	path.add_child(path_follow)

	# Assign the follow reference
	enemy.path_follow = path_follow

	# Add the enemy to the scene
	get_tree().current_scene.add_child(enemy)

func _on_timer_timeout():
	spawn_enemy()
