class_name PathFollow
extends Node

signal arrived

@export var _arrive_threshold := .5
@export var _speed := 1.0
@export var _acceleration := 1.0
@export var _rotation_speed := 8.0
@export var loop := false


@export var _visuals: Node3D
@export var _character: CharacterBody3D

var _waypoint_parent: Node3D
var _waypoints: Array[Node3D]
var _current_waypoint_idx: int = 0
var is_setup: bool = false

func _ready() -> void:
	set_physics_process(self.is_setup)

func setup(waypoint_parent) -> void:
	assert(waypoint_parent != null)
	_waypoint_parent = waypoint_parent
	for child: Node3D in _waypoint_parent.get_children():
		_waypoints.append(child)


	assert(!_waypoints.is_empty())
	self.is_setup = true # Yes, this is needed
	set_physics_process(self.is_setup)


func _physics_process(delta: float) -> void:
	var target : Vector3 = _waypoints[_current_waypoint_idx].global_position
	var direction := _visuals.global_position.direction_to(target)

	var rot_speed = _rotation_speed * delta

	var target_angle := Vector3.BACK.signed_angle_to(direction, Vector3.UP)
	_visuals.global_rotation.y = lerp_angle(_visuals.global_rotation.y, target_angle, rot_speed)

	var tmp_velocity := _character.velocity

	var y_velocity := tmp_velocity.y
	tmp_velocity.y = 0.0
	tmp_velocity = tmp_velocity.move_toward(direction * _speed, _acceleration * delta)

	_character.velocity = tmp_velocity

	# Check if the node has reached the next position and just switch
	var distance_to_next_sqr := (_waypoints[_current_waypoint_idx].global_position - _character.global_position).length_squared()
	if distance_to_next_sqr < _arrive_threshold * _arrive_threshold:
		if loop:
			_current_waypoint_idx = (_current_waypoint_idx + 1) % _waypoints.size()
		else:
			_current_waypoint_idx += 1
			if _current_waypoint_idx >= _waypoints.size():
				arrived.emit()
				set_physics_process(false) # if pooling, set this to true when drawing from pool

	_character.move_and_slide()
