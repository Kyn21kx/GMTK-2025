extends Label

@export var base_color: Color
@export var increasing_color: Color
@export var decreasing_color: Color
@export var color_animation_time := .5
@export var value_animation_time := 3.0

var initial := 0.0
var target := 0.0
var target_color := base_color
var blend : float = 0


func _ready() -> void:
	SignalBus.money_changed.connect(_on_money_changed)
	set("theme_override_colors/font_color", base_color)
	set_process(false)


func _on_money_changed(next: float):
	target = next
	self.blend = 0
	if target > initial:
		target_color = increasing_color
	else:
		target_color = decreasing_color

	if aprox_equal_threshold(target, initial):
		text = "$%d" % initial
		set("theme_override_colors/font_color", base_color)
		set_process(false)
	else:
		set_process(true)

func aprox_equal_threshold(a: float, b: float, threshold: float = 0.05) -> bool:
	return abs(a - b) <= threshold

func _process(delta: float) -> void:
	self.blend += delta / self.value_animation_time
	var current = lerp(initial, target, self.blend)

	var should_continue_process : bool = not aprox_equal_threshold(target, current)
	if !should_continue_process:
		self.initial = target
		set("theme_override_colors/font_color", base_color)

	text = "$%d" % current
	var current_color: Color = get("theme_override_colors/font_color")
	set("theme_override_colors/font_color", current_color.lerp(target_color, delta / color_animation_time))

	set_process(should_continue_process)
