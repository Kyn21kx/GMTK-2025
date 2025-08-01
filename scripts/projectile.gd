class_name GJProjectile
extends Area3D

@export var damage: float = 25.0
@export var speed: float = 20.0

var target: Node3D = null


func _physics_process(delta):
	if not is_instance_valid(target):
		queue_free()
		return

	var direction = global_position.direction_to(target.global_position)
	global_position += direction * speed * delta


func _on_body_entered(body: Node3D):
	if body == target:
		var damageable: Damageable = body.get_node_or_null("Damageable") as Damageable
		if not damageable:
			printerr("Enemy: %s has not a damageable component" %body.get_parent().name)
			return

		damageable.damage(damage)

	queue_free()
