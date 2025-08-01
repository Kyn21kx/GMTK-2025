class_name CameraSystem

extends Camera3D

func _ready() -> void:
	pass

func _unhandled_input(event):
	if event is InputEventMouse:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		# Optionally, set collision masks for specific layers to interact with
		# query.set_collide_with_areas(true) 
		query.set_collide_with_bodies(true)

		var result = space_state.intersect_ray(query)

		if result:
			var clicked_object = result.collider as SelectableItem
			if clicked_object == null:
				return
			clicked_object.hovering_over = true
			print("Clicked object: ", clicked_object.name)
		    # Add your selection logic here (e.g., highlight, select in a list)
		    # Example: clicked_object.modulate = Color.RED # For a MeshInstance3D
