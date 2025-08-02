class_name NotificationMessage
extends Control

@export var notification_label: Label
@export var icon: TextureRect
@export var notification_timer: Timer


func _ready():
	notification_timer.timeout.connect(_on_message_timer_timeout)


func show_temporary_message(text: String, duration: float = 3.0):
	notification_label.text = text
	notification_label.show()

	notification_timer.wait_time = duration
	notification_timer.start()


func _on_message_timer_timeout():
	notification_label.hide()


#Only show icon when you are showing the Open Gate notification
func show_defeat_notification():
	show_temporary_message("Defeat")
	icon.hide()


func show_gate_open_notification():
	show_temporary_message("A new gate has opened.")
	icon.show()


func show_not_enough_money_notification():
	show_temporary_message("Not enough money")
	icon.hide()


func show_waves_completed():
	show_temporary_message("All the enemy waves have been completed.")
	icon.hide()
