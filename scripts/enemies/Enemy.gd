extends CharacterBody2D

@export var speed: float = 100
var path_follow: PathFollow2D = null

func _process(delta):
	if path_follow:
		path_follow.progress += speed * delta
		global_position = path_follow.global_position

		if path_follow.progress_ratio >= 1.0:
			queue_free()  # Enemy reached the end
