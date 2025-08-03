class_name BeatManager

extends Node

static var s_instance: BeatManager = null

signal quarter_beat

signal quaver_beat

signal half_beat

var _bpm: int = 80

var time_elapsed : float = 0

const SECS_IN_MIN : float = 60

var beat_count : int = 0

var quarter_command_index: int = 0

var quaver_command_index: int = 0

var half_command_index: int = 0

const SLOTS_SIZE : int = 4

func get_bpm() -> int:
	return _bpm

func _ready() -> void:
	s_instance = self


func _process(delta: float) -> void:
	var beat_speed : float = BeatManager.s_instance.get_bpm() / SECS_IN_MIN
	var beat_rate: float = 1 / beat_speed
	time_elapsed += delta
	if time_elapsed >= beat_rate:
		time_elapsed = 0;
		self.quarter_beat.emit()
		quarter_command_index = (quarter_command_index + 1) % SLOTS_SIZE
		self.beat_count += 1
	if time_elapsed >= beat_rate / 2:
		self.quaver_beat.emit()
		self.quaver_command_index = (quaver_command_index + 1) % SLOTS_SIZE
	if self.beat_count % 2 == 0:
		self.half_beat.emit()
		self.half_command_index = (half_command_index + 1) % SLOTS_SIZE


