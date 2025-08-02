class_name MainHUD
extends Control

@export var play_pause: Button

@export var atk_basic: StyleBoxTexture
@export var atk_basic_active: StyleBoxTexture
@export var atk_magic: StyleBoxTexture
@export var atk_magic_active: StyleBoxTexture

@onready var notification: NotificationMessage = $Notification as NotificationMessage

static var instance: MainHUD

func _init() -> void:
	instance = self


func _on_play_pause_pressed() -> void:
	if TimeManager._playing:
		TimeManager.pause()
		play_pause.text = "Play"
	else:
		TimeManager.play()
		play_pause.text = "Pause"


func _on_x_1_pressed() -> void:
	TimeManager.change_speed(1)


func _on_x_2_pressed() -> void:
	TimeManager.change_speed(2)


func _on_x_3_pressed() -> void:
	TimeManager.change_speed(3)
