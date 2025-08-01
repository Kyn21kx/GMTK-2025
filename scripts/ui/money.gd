extends Label

@export var base_color: Color
@export var increasing_color: Color
@export var decreasing_color: Color
@export var value_animation_time := 3
@export var color_animation_time := .5

var current := 0.0
var target := 0.0
var target_color := base_color


func _ready() -> void:
	SignalBus.money_changed.connect(_on_money_changed)
	set("theme_override_colors/font_color", base_color)
	set_process(false)


func _on_money_changed(next: float):
	target = next
	if target > current:
		target_color = increasing_color
	else:
		target_color = decreasing_color

	if is_equal_approx(target, current):
		text = "$%d" % current
		set("theme_override_colors/font_color", base_color)
		set_process(false)
	else:
		set_process(true)

func _process(delta: float) -> void:
	current = lerp(current, target, delta / value_animation_time)
	text = "$%d" % current
	var current_color: Color = get("theme_override_colors/font_color")
	set("theme_override_colors/font_color", current_color.lerp(target_color, delta / color_animation_time))

	set_process(not is_equal_approx(target, current))
