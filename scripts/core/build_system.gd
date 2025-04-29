extends Node2D

@export var available_tower_scene: PackedScene  # Selected tower to build
var build_mode: bool = false
var ghost_tower: Node2D = null

var occupied_cells: Dictionary = {}  # Dictionary to track placed towers

func is_buildable_tile(world_position: Vector2) -> bool:
	var buildLayer = $"../TileHolder/BuildLayer"
	var map_coords = buildLayer.local_to_map(world_position)
	var tile_data = buildLayer.get_cell_tile_data(map_coords)
	return tile_data and tile_data.get_custom_data("Buildable")

func is_cell_free(grid_pos: Vector2i) -> bool:
	return not occupied_cells.has(grid_pos)

func _unhandled_input(event):
	if not build_mode:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var build_layer: TileMapLayer = $"../TileHolder/BuildLayer"
		var grid_pos = build_layer.local_to_map(mouse_pos)
		
		if is_buildable_tile(mouse_pos) and is_cell_free(grid_pos):
			place_tower_at(grid_pos)

func place_tower_at(grid_pos: Vector2i):
	var build_layer = $"../TileHolder/BuildLayer"
	var tower_holder = $"../TowerHolder"
	
	var world_grid_pos = build_layer.map_to_local(grid_pos)
	
	var tower = available_tower_scene.instantiate()
	tower.position = world_grid_pos
	
	# Fix sprite depth (Y-sorting)
	tower.z_index = int(grid_pos.y)
	
	tower_holder.add_child(tower)
	occupied_cells[grid_pos] = tower
	
	stop_build_mode()

func _process(_delta):
	if not build_mode:
		return
	
	if ghost_tower:
		update_ghost_tower()

func update_ghost_tower():
	var build_layer = $"../TileHolder/BuildLayer"
	var mouse_pos = get_global_mouse_position()
	var grid_pos = build_layer.local_to_map(mouse_pos)
	var world_grid_pos = build_layer.map_to_local(grid_pos)
	
	ghost_tower.position = world_grid_pos
	var can_place = is_buildable_tile(mouse_pos) and is_cell_free(grid_pos)
	
	var modulate_color = Color(0, 1, 0, 0.5) if can_place else Color(1, 0, 0, 0.5)
	ghost_tower.modulate = modulate_color

func start_build_mode(tower_scene: PackedScene):
	build_mode = true
	available_tower_scene = tower_scene
	
	ghost_tower = tower_scene.instantiate()
	var range_indicator = ghost_tower.get_node("RangeIndicator") if ghost_tower.has_node("RangeIndicator") else null
	if range_indicator:
		range_indicator.visible = true
		range_indicator.modulate = Color(1, 1, 1, 0.5)  # Semi-transparent if you want
	ghost_tower.modulate = Color(1, 1, 1, 0.5)
	ghost_tower.set_physics_process(false)
	ghost_tower.set_process(false)
	ghost_tower.z_index = 10000  # Always on top
	add_child(ghost_tower)

func stop_build_mode():
	build_mode = false
	if ghost_tower:
		ghost_tower.queue_free()
		ghost_tower = null
