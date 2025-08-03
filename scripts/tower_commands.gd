class_name TowerCommands
extends Node

const PROJECTILE_SCENE = preload("res://scenes/projectil.tscn")

var slots: Array[ProjectilesManager.Command] = []
@export
var overhead_ui: TowerGUI

# At bpm = 2 bps

const SECS_IN_MIN : float = 60

@export
var shooter: Turret = null
var time_elapsed : float = 0
var current_command_index: int = 0

func _ready() -> void:
	# Default update_overhead_ui to a 4 slot command buffer, maybe we support others later
	for i in range(4):
		slots.push_back(ProjectilesManager.Command.BasicAttack)
	BeatManager.s_instance.quarter_beat.connect(self.on_quarter_note)

func position_3d_to_screen(world_position: Vector3) -> Vector2:
	var camera = get_viewport().get_camera_3d()
	var screen_position : Vector2 = camera.unproject_position(world_position)

	return screen_position


func update_overhead_ui():
	var overhead_position := self.shooter.global_position
	var camera = get_viewport().get_camera_3d()

	var distance = camera.global_position.distance_to(overhead_position)

	var reference_distance = 5.0
	var base_scale = 1.0
	var min_scale = 0.1
	var max_scale = 1.0

	var scale_factor = (reference_distance / distance) * base_scale

	scale_factor = clamp(scale_factor, min_scale, max_scale)

	self.overhead_ui.position = position_3d_to_screen(overhead_position)
	self.overhead_ui.scale = Vector2(scale_factor, scale_factor)

	# Use the command index to select which one is active
	self.overhead_ui.set_active_slot(BeatManager.s_instance.quarter_command_index)

func on_quarter_note():
	if (self.shooter.turret_type != Turret.Type.Default):
		return
	execute_command(slots[BeatManager.s_instance.quarter_command_index])

func on_quaver_note():
	if (self.shooter.turret_type != Turret.Type.Light):
		return
	execute_command(slots[BeatManager.s_instance.quaver_command_index])

func on_half_note():
	pass
	
func _process(_delta: float) -> void:
	self.update_overhead_ui()

func execute_command(command: ProjectilesManager.Command):
	var projectile_scene := ProjectilesManager.s_instance.projectile_scenes[command]
	self.shooter.shoot(projectile_scene)
