extends CharacterBody3D

class_name EnemyAgent

@export var _path_follow: PathFollow
@export var _attack_tower := false
@export var _attack_timer: Timer
@export var _attack_range := 10.0
@export var _attack_cooldown := 1.0
@export var _muzzle: Marker3D
@export var _coin_packed_scene: PackedScene

var _waypoint_parent: Node3D
var game_manager: GameManager

func _ready() -> void:
	game_manager = GameManager.instance
	_attack_timer.wait_time = _attack_cooldown
	set_process(_attack_tower)

func start_path(waypoint_parent: Node3D):
	_waypoint_parent = waypoint_parent
	_path_follow.setup(_waypoint_parent)
	pass

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
	var root := self.get_tree().root
	var coin_node : Node3D = self._coin_packed_scene.instantiate()
	coin_node.global_position = self.global_position
	root.add_child(coin_node)
	queue_free()


func _on_attack_timer_timeout() -> void:
	set_process(true)
