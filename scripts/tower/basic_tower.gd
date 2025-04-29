extends Node2D

@export var fire_range: float = 100.0
@export var fire_rate: float = 1.0
@onready var range_area: Area2D = $Area2D

var enemies_in_range: Array = []
var time_since_last_shot := 0.0

func _ready():
	# Set collision shape radius based on range
	var circle = range_area.get_node("CollisionShape2D").shape
	if circle is CircleShape2D:
		circle.radius = fire_range

	range_area.body_entered.connect(_on_body_entered)
	range_area.body_exited.connect(_on_body_exited)

func _process(delta):
	time_since_last_shot += delta
	if enemies_in_range.size() > 0 and time_since_last_shot >= fire_rate:
		_shoot(enemies_in_range[0])
		time_since_last_shot = 0.0

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_body_exited(body):
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func _shoot(target):
	if target and target.is_inside_tree():
		var projectile = preload("res://scenes/projectiles/arrow_projectile.tscn").instantiate()
		projectile.global_position = global_position
		projectile.target = target
		get_tree().current_scene.add_child(projectile)  # Or tower_holder, depends where you want it
