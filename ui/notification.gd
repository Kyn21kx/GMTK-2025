extends Control

@export var notification_label: Label
@export var icon: TextureRect

#Only show icon when you are showing the Open Gate notification
func show_defeat_notification():
	notification_label.text = "Defeat"
	icon.hide()

func show_gate_open_notification():
	notification_label.text = "A new gate has opened."
	icon.show()

func show_not_enough_money_notification():
	notification_label.text = "Not enough money"
	icon.hide()
