class_name Damageable
extends Node

@export
var _health: int = 100

func damage(amount: int):
	_health -= amount
	if (_health <= 0):
		die()

func die():
	# TODO: Get enemy type here and switch on it or smth
	assert(get_parent() != null)
	get_parent().queue_free();
	pass
