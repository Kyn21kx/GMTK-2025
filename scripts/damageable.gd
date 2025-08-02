class_name Damageable
extends Node

signal died

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
		died.emit()
