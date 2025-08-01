extends Node

var _money := 0.0
var _score := 0.0


func add_money(delta: float) -> void:
	_money += delta
	SignalBus.money_changed.emit(_money)


func add_score(delta: float) -> void:
	_score += delta
	SignalBus.score_changed.emit(delta)
