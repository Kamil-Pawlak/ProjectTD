extends CharacterBody2D

var start_pos: Vector2
var target: CharacterBody2D
var speed: float = 300.0
var damage: float = 30.0


func _physics_process(_delta: float) -> void:
	if not target or not target.is_inside_tree():
		queue_free()
		return
	
	var direction: Vector2 = (target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	rotation = (target.global_position - global_position).angle() + PI/2

	if global_position.distance_to(target.global_position) < 5:
		_hit_target()


func _hit_target():
	if target and target.is_inside_tree() and target.has_method("take_damage"):
		target.take_damage(damage)
		var hit_particles = preload("res://scenes/projectiles/hit_particles.tscn").instantiate()
		hit_particles.global_position = global_position
		get_tree().current_scene.add_child(hit_particles)
		hit_particles.emitting = true
	queue_free()
