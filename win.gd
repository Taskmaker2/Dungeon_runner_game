extends Control

func _ready():
	var Player = get_parent().get_parent().get_parent().get_node("Player")
	$Panel/VBoxContainer/HBoxContainer/Label.text += str(Player.swordLevel) 
	$Panel/VBoxContainer/HBoxContainer/Label2.text += str(Player.waveLevel)
	$Panel/VBoxContainer/HBoxContainer/Label3.text += str(Player.fireballLevel)
func _on_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_button_2_pressed():
	get_tree().quit()
	


