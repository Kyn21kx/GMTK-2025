class_name TowerCommands
extends Node

enum Command { None, BasicAttack, MagicAttack, Barrier }

var slots: Array[Command] = []

# At 120 bpm = 2 bps

const SECS_IN_MIN : float = 60

var time_elapsed : float = 0
var current_command_index: int = 0

func _ready() -> void:
	# Default initialize to a 4 slot command buffer, maybe we support others later
	for i in range(4):
		slots.push_back(Command.None)

func _process(delta: float) -> void:
	var beat_speed : float = BeatManager.s_instance.get_bpm() / SECS_IN_MIN
	var beat_rate: float = 1 / beat_speed
	self.time_elapsed += delta
	if time_elapsed >= beat_rate:
		self.time_elapsed = 0;
		self.execute_command(self.slots[current_command_index])
		self.current_command_index = (self.current_command_index + 1) % self.slots.size()
	pass

func execute_command(command: Command):
	print("Executed: " + str(command))
	pass
