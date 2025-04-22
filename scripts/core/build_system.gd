extends Node2D


func is_buildable_tile(world_position: Vector2) -> bool:
	var buildLayer = $"../TileHolder/BuildLayer"
	var map_coords = buildLayer.local_to_map(world_position)
	var tile_data = buildLayer.get_cell_tile_data(map_coords)
	if tile_data and tile_data.get_custom_data("Buildable"):
		return true
	return false


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		print(is_buildable_tile(mouse_pos))
		if is_buildable_tile(mouse_pos):
			place_tower_at(mouse_pos)

func place_tower_at(world_position: Vector2):
	var build_layer: TileMapLayer = $"../TileHolder/BuildLayer"
	var grid_pos = build_layer.local_to_map(world_position)
	var world_grid_pos = build_layer.map_to_local(grid_pos)
	var tile_size = build_layer.tile_set.tile_size
	var tower_holder = $"../TowerHolder"

	var tower = preload("res://scenes/towers/BasicTower.tscn").instantiate()
	tower.position = world_grid_pos + Vector2(tile_size) / 2
	tower_holder.add_child(tower)  # Create a node to organize towers in MainScene
