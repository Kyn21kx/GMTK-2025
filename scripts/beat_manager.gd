class_name BeatManager

extends Node

static var s_instance: BeatManager = null

var _bpm: int = 120

func get_bpm() -> int:
	return _bpm

func _ready() -> void:
	s_instance = self
