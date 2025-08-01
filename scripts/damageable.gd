class_name Damageable
extends Node

@export
var _health: float = 100
@export
var _attack_type_allowed: ProjectilesManager.Command

func damage(amount: float, damage_type: ProjectilesManager.Command):
	if damage_type != self._attack_type_allowed:
		# Play a sound or something
		print("Deflected attack...")

	_health -= amount
	if (_health <= 0):
		die()

func die():
	# TODO: Get enemy type here and switch on it or smth
	assert(get_parent() != null)
	get_parent().queue_free();
	pass
