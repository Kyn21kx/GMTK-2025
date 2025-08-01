extends Label


func _ready() -> void:
	TimeManager.played.connect(_on_played)
	TimeManager.paused.connect(_on_paused)
	TimeManager.speed_changed.connect(_on_speed_changed)


func _on_played() -> void:
	set_process(true)


func _on_paused() -> void:
	set_process(false)


func _on_speed_changed(new_speed: float) -> void:
	set_process(true)


func _process(_delta: float) -> void:
	var time := TimeManager._current_time
	var minutes := int(time / 60)
	var seconds := int(time - (minutes * 60))
	text = "%02d:%02d" % [minutes, seconds]
