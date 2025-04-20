extends Camera2D

var _target_zoom: float = 1.0
@export var drag_limit_x: float = 500
@export var drag_limit_y: float = 400

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask & (MOUSE_BUTTON_MASK_RIGHT | MOUSE_BUTTON_MASK_MIDDLE):
			_drag_camera(event.relative / zoom)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_out()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_in()
			

func _drag_camera(delta: Vector2) -> void:
	var new_x = position.x - delta.x
	var new_y = position.y - delta.y

	# Apply horizontal limit
	if abs(new_x) <= drag_limit_x:
		position.x = new_x
	else:
		position.x = clamp(new_x, -drag_limit_x, drag_limit_x)

	# Apply vertical limit
	if abs(new_y) <= drag_limit_y:
		position.y = new_y
	else:
		position.y = clamp(new_y, -drag_limit_y, drag_limit_y)


const MIN_ZOOM: float = 0.8
const MAX_ZOOM: float = 2.0
const ZOOM_INCREMENT: float = 0.05

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)
	
func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
	
const ZOOM_RATE: float = 15.0
func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		_target_zoom * Vector2.ONE,
		ZOOM_RATE * delta
	)
	set_physics_process(
		not is_equal_approx(zoom.x, _target_zoom)
	)
	
