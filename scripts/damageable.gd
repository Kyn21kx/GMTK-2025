class_name Damageable
extends Node

signal died

@export
var _health: float = 100

func damage(amount: float):
	_health -= amount
	if (_health <= 0):
		died.emit()
