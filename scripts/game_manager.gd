class_name GameManager
extends Node

@export var waypoints_container: Node3D
static var instance: GameManager = null

func _init() -> void:
	instance = self
