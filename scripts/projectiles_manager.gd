class_name ProjectilesManager
extends Node

static var s_instance: ProjectilesManager = null

enum Command { BasicAttack, MagicAttack, Barrier }

@export
var projectile_scenes: Dictionary[Command, PackedScene]

func _ready() -> void:
	s_instance = self
	assert(self.projectile_scenes.size() == Command.size(), "Every command should have a projectile associated with it")
