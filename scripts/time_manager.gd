## anything playtime related should listen to this class
extends Node

signal played()
signal paused()
## I added a speed change since it's a common feature in TD games, if it's not needed (being a rithm game?) just remove it from the hud - Camus
signal speed_changed(new_speed: float)

var _current_time := 0.0
var _speed := 1.0
var _playing := true


func toggle():
	if _playing:
		pause()
	else:
		play()


func play() -> void:
	_playing = true
	get_tree().paused = false
	played.emit()


func pause() -> void:
	_playing = false
	get_tree().paused = true
	paused.emit()


func change_speed(new_speed: float) -> void:
	_speed = new_speed
	Engine.time_scale = _speed
	get_tree().paused = false
	speed_changed.emit(new_speed)


func _process(delta: float) -> void:
	_current_time += delta * _speed
