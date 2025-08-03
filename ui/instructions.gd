extends Control


func _on_continue_button_down() -> void:
	%howtoplay1.visible = false
	%howtoplay2.visible = true


func _on_play_button_down() -> void:
	pass # Replace with function body.
	$".".visible = false
