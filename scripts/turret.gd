class_name Turret
extends Node3D

@export var detection_area: Area3D
@export var muzzle: Marker3D

var enemies_in_range: Array = []
var target: Node3D = null


func _ready():
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)


func _on_detection_area_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)


func _on_detection_area_body_exited(body):
	enemies_in_range.erase(body)
	if target == body:
		target = null
		find_new_target()


func _process(_delta: float):
	if target == null and not enemies_in_range.is_empty():
		find_new_target()

	if target:
		look_at(target.global_position)

func find_new_target():
	enemies_in_range = enemies_in_range.filter(func(e): return is_instance_valid(e))
	if not enemies_in_range.is_empty():
		target = enemies_in_range[0]
	else:
		target = null


func shoot(p_projectile: PackedScene):
	if not is_instance_valid(target):
		find_new_target()
		return

	var projectile: GJProjectile = p_projectile.instantiate()
	projectile.target = target
	get_tree().root.add_child(projectile)
	projectile.global_position = muzzle.global_position
