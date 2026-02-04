extends Node2D

@onready var camera: Camera2D = get_node_or_null("player/Camera2D")

func _ready() -> void:
	if camera == null:
		push_error("World script: Could not find camera at 'player/Camera2D' from " + str(get_path()))
		return

	camera.make_current()

	# Find TileMapLayers anywhere under this world node.
	var layers: Array[TileMapLayer] = _get_tilemap_layers_recursive(self)

	print("World script running on: ", get_path())
	print("Camera: ", camera.get_path())
	print("TileMapLayers found: ", layers.size())
	for l in layers:
		print(" - ", l.get_path(), " used_rect=", l.get_used_rect())

	var world_rect: Rect2 = _get_world_bounds_from_layers(layers)
	print("WORLD RECT (world px): ", world_rect)

	if world_rect.size == Vector2.ZERO:
		push_warning("World script: No used tiles detected across all TileMapLayers; camera limits not set.")
		return

	_apply_camera_limits(world_rect)

	print("LIMITS L/T/R/B = ",
		camera.limit_left, ", ",
		camera.limit_top, ", ",
		camera.limit_right, ", ",
		camera.limit_bottom
	)

func _get_tilemap_layers_recursive(root: Node) -> Array[TileMapLayer]:
	var out: Array[TileMapLayer] = []
	for child in root.get_children():
		if child is TileMapLayer:
			out.append(child)
		out.append_array(_get_tilemap_layers_recursive(child))
	return out

func _get_world_bounds_from_layers(layers: Array[TileMapLayer]) -> Rect2:
	var first := true
	var combined := Rect2()

	for layer in layers:
		var used: Rect2i = layer.get_used_rect()
		if used == Rect2i():
			continue

		if layer.tile_set == null:
			push_warning("TileMapLayer has no TileSet: " + str(layer.get_path()))
			continue

		var ts: Vector2 = Vector2(layer.tile_set.tile_size)

		# Corners in LOCAL pixel space (tile coords -> pixels).
		var p0_local: Vector2 = Vector2(used.position) * ts
		var p1_local: Vector2 = Vector2(used.position + Vector2i(used.size.x, 0)) * ts
		var p2_local: Vector2 = Vector2(used.position + Vector2i(0, used.size.y)) * ts
		var p3_local: Vector2 = Vector2(used.position + used.size) * ts

		# Transform each corner to WORLD space using full global transform.
		var xf: Transform2D = layer.global_transform
		var p0: Vector2 = xf * p0_local
		var p1: Vector2 = xf * p1_local
		var p2: Vector2 = xf * p2_local
		var p3: Vector2 = xf * p3_local

		var r := Rect2(p0, Vector2.ZERO)
		r = r.expand(p1)
		r = r.expand(p2)
		r = r.expand(p3)

		if first:
			combined = r
			first = false
		else:
			combined = combined.merge(r)

	return combined if not first else Rect2()

func _apply_camera_limits(world_rect: Rect2) -> void:
	# Camera limits constrain the CAMERA CENTER, so subtract/add half the view.
	var viewport_size: Vector2 = get_viewport_rect().size
	var zoom: Vector2 = camera.zoom
	var half_view: Vector2 = (viewport_size * zoom) * 0.5

	camera.limit_left   = int(world_rect.position.x + half_view.x)
	camera.limit_top    = int(world_rect.position.y + half_view.y)
	camera.limit_right  = int(world_rect.position.x + world_rect.size.x - half_view.x)
	camera.limit_bottom = int(world_rect.position.y + world_rect.size.y - half_view.y)

	# Optional safety: if the world is smaller than the view, limits can invert.
	# Clamp to avoid weird behavior.
	if camera.limit_right < camera.limit_left:
		var mid_x := int(world_rect.position.x + world_rect.size.x * 0.5)
		camera.limit_left = mid_x
		camera.limit_right = mid_x
	if camera.limit_bottom < camera.limit_top:
		var mid_y := int(world_rect.position.y + world_rect.size.y * 0.5)
		camera.limit_top = mid_y
		camera.limit_bottom = mid_y
