class_name SelectableItem

extends StaticBody3D

@export
var mesh_instances: Array[MeshInstance3D] = []

@export
var selectable_target: Node3D = null

var _material_overlay: StandardMaterial3D

var hovering_over = false

func _ready() -> void:
	assert(!self.mesh_instances.is_empty(), "Need to set the mesh instances for a selectable item to toggle the outline")
	assert(self.selectable_target != null, "Selectable object must have a valid selectable target (i.e, parent node)")
	# assert(self.mesh_instances.material_overlay != null, "A material overlay is needed for the outline of a selectable item")
	self.input_ray_pickable = true
	self._material_overlay = self.mesh_instances[0].material_overlay
	# Disable the overlay at start
	for instance: MeshInstance3D in self.mesh_instances:
		instance.material_overlay = null

func _process(_delta: float) -> void:
	if (hovering_over):
		enable_outline()
	else:
		disable_outline()
	self.hovering_over = false # External script to set this to true

func enable_outline() -> void:
	for instance: MeshInstance3D in self.mesh_instances:
			instance.material_overlay = self._material_overlay

func disable_outline() -> void:
	for instance: MeshInstance3D in self.mesh_instances:
		instance.material_overlay = null
