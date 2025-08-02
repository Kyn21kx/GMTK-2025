class_name WaveManager
extends Node

signal wave_started(wave_number)
signal all_waves_completed

@export var enemy_scene: PackedScene
@export var enemy_path: Path3D
@export var spawn_position: Node3D

@export var waves: Array[Dictionary] = [
	{"enemy_count": 5, "spawn_delay": 2.0, "wave_delay": 10.0},
	{"enemy_count": 10, "spawn_delay": 1.5, "wave_delay": 15.0},
	{"enemy_count": 15, "spawn_delay": 1.0, "wave_delay": 20.0},
	{"enemy_count": 1, "spawn_delay": 1.0, "wave_delay": 5.0}
]

@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveTimer

var current_wave_index = -1
var enemies_spawned_in_wave = 0
var is_in_wave = false


func _ready():
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	wave_timer.timeout.connect(_on_wave_timer_timeout)

	start_next_wave()


func start_next_wave():
	current_wave_index += 1

	if current_wave_index >= waves.size():
		print("Todas las oleadas completadas.")
		all_waves_completed.emit()
		set_process(false)
		return

	is_in_wave = true
	enemies_spawned_in_wave = 0

	var current_wave_data = waves[current_wave_index]

	spawn_timer.wait_time = current_wave_data["spawn_delay"]
	spawn_timer.start()

	_on_spawn_timer_timeout()

	wave_started.emit(current_wave_index + 1)


func _on_spawn_timer_timeout():
	if not is_in_wave:
		return

	var current_wave_data = waves[current_wave_index]

	if enemies_spawned_in_wave >= current_wave_data["enemy_count"]:
		is_in_wave = false
		spawn_timer.stop()

		wave_timer.wait_time = current_wave_data["wave_delay"]
		wave_timer.start()
		return

	spawn_enemy()
	enemies_spawned_in_wave += 1


func _on_wave_timer_timeout():
	start_next_wave()


func spawn_enemy():
	if not enemy_scene:
		printerr("ERROR: La escena del enemigo no está asignada en el WaveManager.")
		return

	var enemy_instance: CharacterBody3D = enemy_scene.instantiate() as CharacterBody3D
	var enemy_spawn_pos: Vector3 = spawn_position.global_position
	enemy_instance.position = enemy_spawn_pos
	get_parent().add_child(enemy_instance)
