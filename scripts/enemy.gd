extends CharacterBody3D

@export var _waypoint_parent: Node3D
@export var _path_follow: PathFollow
@export var _attack_tower := false
@export var _attack_timer: Timer
@export var _attack_range := 10.0
@export var _attack_cooldown := 1.0
@export var _muzzle: Marker3D


func _ready() -> void:
	_path_follow.setup(_waypoint_parent)
	_attack_timer.wait_time = _attack_cooldown
	set_process(_attack_tower)


func _process(delta: float) -> void:
	for turret in Turret.turrets:
		if not is_instance_valid(turret):
			return

		var distance_squared := global_position.distance_squared_to(turret.global_position)
		if distance_squared < (_attack_range * _attack_range):
			shoot(turret)


func shoot(target: Node3D) -> void:
	var projectile: GJProjectile = PoolManager.get_next("projectil")
	if not projectile: # pool not ready, wait for next frame
		return

	projectile.target = target
	get_tree().root.add_child(projectile)
	projectile.global_position = _muzzle.global_position

	set_process(false)
	_attack_timer.start()

func _on_died() -> void:
	queue_free()


func _on_attack_timer_timeout() -> void:
	set_process(true)
