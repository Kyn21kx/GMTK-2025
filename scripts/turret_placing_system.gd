class_name TurretPlacingSystem
extends Node3D

static var s_instance: TurretPlacingSystem

@export
var _available_turrets_by_name: Dictionary[Turret.Type, PackedScene]

@export
var ghost_material: StandardMaterial3D
var initial_ghost_emission: Color

@export
var allowed_locations_parent: Node3D
var allowed_locations: Array[Node] = []

# var original_materials: Array[StandardMaterial3D] = []
var current_turret_placing_type: Turret.Type = Turret.Type.Light
var is_placing: bool = false
var ghost_node: Node3D

func _ready() -> void:
	assert(!self._available_turrets_by_name.is_empty(), "Please add some turrets")
	assert(self.ghost_material, "Set the ghost material!")
	self.allowed_locations = self.allowed_locations_parent.get_children()
	assert(!self.allowed_locations.is_empty())
	self.initial_ghost_emission = self.ghost_material.emission
	s_instance = self

func _process(delta: float) -> void:
	# Check if we pressed the place button
	if (Input.is_action_just_pressed("add_turret")):
		self.is_placing = !self.is_placing
		if (self.is_placing):
			instantiate_ghost_node()
		elif (self.ghost_node != null):
			self.ghost_node.queue_free()

	if (self.is_placing):
		self.drag_ghost_node(delta)


func apply_mat_to_mesh_instances(root: Node3D, action: Callable) -> void:
	# Check if this node is a MeshInstance3D
	if root is MeshInstance3D:
		action.call(root)

	# Recurse into children
	for child in root.get_children():
		if child is Node3D:
			apply_mat_to_mesh_instances(child, action)

func instantiate_ghost_node() -> void:
	self.ghost_node = self._available_turrets_by_name[self.current_turret_placing_type].instantiate()
	# Find all the mesh instances of the mesh instances
	apply_mat_to_mesh_instances(self.ghost_node, func action(mesh: MeshInstance3D):
		mesh.material_override = self.ghost_material
		pass
	)
	self.add_child(self.ghost_node)


func get_mouse_world_position() -> Vector3:
	var viewport = get_viewport()
	var mouse_position_2d = viewport.get_mouse_position()
	var camera = viewport.get_camera_3d()

	var ray_origin = camera.project_ray_origin(mouse_position_2d)
	var ray_normal = camera.project_ray_normal(mouse_position_2d)

	const max_reach := 1000.0
	var ray_end = ray_origin + ray_normal * max_reach
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)

	
	var mouse_world_position_3d: Vector3

	if result.has("position"):
		mouse_world_position_3d = result["position"]
	else:
		mouse_world_position_3d = ray_end 	

	return mouse_world_position_3d

func drag_ghost_node(delta) -> void:
	# Get mouse pos in World space
	var mouse_pos : Vector3 = get_mouse_world_position()
	# Clamp to the ground
	mouse_pos.y = 0
	self.ghost_node.global_position = mouse_pos

	var closest_node: Node3D = null
	var min_dis: float = 1.79769e308
	for location: Node3D in allowed_locations:
		var sqr_dis := self.ghost_node.global_position.distance_squared_to(location.global_position)
		const child_count_original = 2
		if (location.get_child_count() <= child_count_original && sqr_dis < min_dis):
			closest_node = location
			min_dis = sqr_dis

	if (min_dis > 1):
		self.ghost_material.emission = Color.RED
		return

	self.ghost_material.emission = self.initial_ghost_emission
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		self.is_placing = false
		self.ghost_node.reparent(closest_node)
		self.ghost_node.position = Vector3.ZERO
		apply_mat_to_mesh_instances(self.ghost_node, func (mesh: MeshInstance3D):
			mesh.material_override = null
			pass
		)
		self.ghost_node = null
	# Change the color depending on our proximity to the nodes that
	pass
