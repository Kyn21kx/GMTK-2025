class_name Damageable
extends Node

@export
var _health: float = 100

func damage(amount: float):
	_health -= amount
	if (_health <= 0):
		die()

func die():
	# TODO: Get enemy type here and switch on it or smth
	assert(get_parent() != null)
	get_parent().queue_free();
	pass
