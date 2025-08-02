class_name CameraSystem

extends Camera3D

@export
var speed: float = 1
var last_mouse_posistion: Vector2 = Vector2.ZERO
var selected_entity: Node3D = null
var movement_blend: float = 0
var selected_position: Vector3
var zoom_limit: float = 10
var initial_height: float
var target_zoom_y: float
@export var zoom_blend_speed: float = 4.0
@export var zoom_step: float = 2.0


func _ready() -> void:
	self.initial_height = self.global_position.y
	self.target_zoom_y = self.global_position.y
	pass

func _process(delta: float) -> void:
	self.handle_hover_item()
	self.handle_mouse_movement(delta)
	if selected_entity != null:
		self.lock_to_target(delta)

func lock_to_target(delta: float) -> void:
	if (self.movement_blend >= 1):
		return

	self.movement_blend += delta * self.speed
	self.global_position = self.global_position.lerp(self.selected_position, self.movement_blend)

func get_target_position_at_center() -> Vector3:
	var viewport_size: Vector2 = self.get_viewport().get_visible_rect().size
	var screen_center := Vector2(viewport_size.x / 2, viewport_size.y * 0.4)

	var distance_to_target := self.global_position.distance_to(self.selected_entity.global_position)
	var center_world_pos := self.project_position(screen_center, distance_to_target)
	var target_current_world_pos: Vector3 = self.selected_entity.global_position
	
	var world_space_offset: Vector3 = center_world_pos - target_current_world_pos

	var target_pos : Vector3 = self.global_position - world_space_offset
	target_pos.y = self.global_position.y # Ignore height, lol
	return target_pos

func handle_mouse_movement(delta: float) -> void:
	# Check if the mouse is at the edges of the screen
	var mouse_position: Vector2 = self.get_viewport().get_mouse_position()
	var window_size: Vector2i = self.get_viewport().get_window().size
	# We'll do some percentage of tolerance for the mouse to trigger the movement
	var tolerance_range := Vector2(window_size.x * 0.1, window_size.y * 0.1)

	var velocity := Vector3.ZERO

	if mouse_position.x > window_size.x - tolerance_range.x:
		velocity.x = 1
	elif mouse_position.x < 0 + tolerance_range.x:
		velocity.x = -1
	if mouse_position.y > window_size.y - tolerance_range.y:
		velocity.z = 1
	elif mouse_position.y < 0 + tolerance_range.y:
		velocity.z = -1
	
	if Input.is_action_just_pressed("mouse_wheel_down"):
		self.target_zoom_y += self.zoom_step
	elif Input.is_action_just_pressed("mouse_wheel_up"):
		self.target_zoom_y -= self.zoom_step
	
	self.target_zoom_y = clampf(self.target_zoom_y, self.initial_height, self.zoom_limit)

	# Horrible code, sorry
	var current_position := self.global_position
	current_position.y = lerp(current_position.y, self.target_zoom_y, delta * self.zoom_blend_speed)
	velocity.y = 0
	velocity = velocity.normalized()
	print("Velocity: ", velocity)
	current_position += velocity * self.speed * delta
	current_position.y = clampf(current_position.y, self.initial_height, self.zoom_limit)

	self.global_position = current_position
	self.last_mouse_posistion = mouse_position



func handle_hover_item() -> void:
	if TurretPlacingSystem.s_instance.is_placing:
		return
	var mouse_position: Vector2 = self.get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_position)

	const max_dectection_distance : float = 1000
	var to = from + project_ray_normal(mouse_position) * max_dectection_distance
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.set_collide_with_bodies(true)

	var result = space_state.intersect_ray(query)

	if !result:
		return

	var hovered_object = result.collider as SelectableItem
	if hovered_object == null:
		return
	hovered_object.hovering_over = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_object_selection(hovered_object)


func handle_object_selection(selectable_item: SelectableItem) -> void:
	var selected_type: SelectableItem.Type = selectable_item.selectable_type
	match selected_type:
		SelectableItem.Type.Turret:
			self.selected_entity = selectable_item.selectable_target
			self.movement_blend = 0
			self.selected_position = self.get_target_position_at_center()
		SelectableItem.Type.Coin:
			selectable_item.selectable_target.queue_free()
			const default_money_amount: float = 10.0 
			Player.add_money(default_money_amount)
			pass
