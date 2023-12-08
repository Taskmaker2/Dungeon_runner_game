extends Control


func _on_button_pressed():
	get_tree().paused = false;
	visible = false;


func _on_button_2_pressed():
	get_tree().quit()
