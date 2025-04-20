extends CharacterBody2D

@export var speed: float = 100
var path_follow: PathFollow2D = null
var previous_position

var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player = $Sprite2D/AnimationPlayer
	previous_position = global_position

func _process(delta):
	if path_follow:
		path_follow.progress += speed * delta
		global_position = path_follow.global_position
		
		var direction = global_position - previous_position
		_update_animation(direction)
		previous_position = global_position
		if path_follow.progress_ratio >= 1.0:
			queue_free()  # Enemy reached the end
			
			
func _update_animation(direction: Vector2) -> void:
	if direction.length() < 0.1:
		return

	if abs(direction.x) > abs(direction.y):
		# Side movement
		$Sprite2D.flip_h = direction.x < 0
		_play_anim_if_not_playing("walk_right")  # Always play right anim and flip if needed
	else:
		# Vertical movement
		$Sprite2D.flip_h = false  # Reset flip for vertical movement
		if direction.y > 0:
			_play_anim_if_not_playing("walk_down")
		else:
			_play_anim_if_not_playing("walk_up")

func _play_anim_if_not_playing(name: String) -> void:
	if anim_player.current_animation != name:
		anim_player.play(name)
