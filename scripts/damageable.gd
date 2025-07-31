class_name Damageable
extends Node

@export
var _health: int = 100

func damage(amount: int):
	self._health -= amount
	if (self._health <= 0):
		self.die()

func die():
	# TODO: Get enemy type here and switch on it or smth
	assert(self.get_parent() != null)
	self.get_parent().queue_free();
	pass
