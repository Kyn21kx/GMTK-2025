class_name TowerCommands
extends Node

const PROJECTILE_SCENE = preload("res://scenes/projectil.tscn")

var slots: Array[ProjectilesManager.Command] = []

# At bpm = 2 bps

const SECS_IN_MIN : float = 60

@export
var shooter: Turret = null
var time_elapsed : float = 0
var current_command_index: int = 0

func _ready() -> void:
	# Default initialize to a 4 slot command buffer, maybe we support others later
	for i in range(4):
		slots.push_back(ProjectilesManager.Command.BasicAttack)

func _process(delta: float) -> void:
	var beat_speed : float = BeatManager.s_instance.get_bpm() / SECS_IN_MIN
	var beat_rate: float = 1 / beat_speed
	time_elapsed += delta
	if time_elapsed >= beat_rate:
		time_elapsed = 0;
		execute_command(slots[current_command_index])
		current_command_index = (current_command_index + 1) % slots.size()

func execute_command(command: ProjectilesManager.Command):
	var projectile_scene := ProjectilesManager.s_instance.projectile_scenes[command]
	self.shooter.shoot(projectile_scene)
