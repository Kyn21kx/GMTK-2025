class_name PathFollow
extends RigidBody3D

@export
var _speed: float = 1

@export
var _waypoint_parent: Node3D

var _waypoints: Array[Node3D]

var _current_waypoint_idx: int = 0

func _ready() -> void:
	assert(self._waypoint_parent != null)
	for child: Node3D in self._waypoint_parent.get_children():
		self._waypoints.append(child)
	self._waypoints.reverse() # Temporary fix, we need to remove this
	var target : Vector3 = self._waypoints[self._current_waypoint_idx].global_position
	var direction : Vector3 = (target - self.global_position).normalized()
	self.linear_velocity = direction * self._speed;

func _physics_process(_delta: float) -> void:
	assert(!self._waypoints.is_empty())
	# Check if the node has reached the next position and just switch
	var distance_to_next_sqr := (self._waypoints[self._current_waypoint_idx].global_position - self.global_position).length_squared()
	if distance_to_next_sqr < 2 * 2:
		self._current_waypoint_idx = (self._current_waypoint_idx + 1) % self._waypoints.size()
