extends Label

@export var value_animation_time := 1

var current := 0.0
var target := 0.0


func _ready() -> void:
	SignalBus.score_changed.connect(_on_score_changed)
	set_process(false)


func _on_score_changed(next: float):
	target = next

	if is_equal_approx(target, current):
		text = "%d" % current
		set_process(false)
	else:
		set_process(true)


func _process(delta: float) -> void:
	current = lerp(current, target, delta / value_animation_time)
	text = "%d" % current

	set_process(not is_equal_approx(target, current))
