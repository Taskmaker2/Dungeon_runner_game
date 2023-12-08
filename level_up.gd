extends Control
@onready var swords = load("res://effects/effects.tscn")
@onready var waves = load("res://effects/wave.tscn")
@onready var fireballs = load("res://effects/fireball_caster.tscn")

func _on_button_pressed():
	var sword = swords.instantiate()
	get_parent().get_parent().add_child(sword)
	get_tree().paused = false;
	visible = false;
	get_parent().get_parent().swordLevel +=1

func _on_button_2_pressed():
	var wave = waves.instantiate()
	get_parent().get_parent().add_child(wave)
	get_tree().paused = false;
	visible = false;
	get_parent().get_parent().waveLevel +=1

func _on_button_3_pressed():
	var fireball = fireballs.instantiate()
	get_parent().get_parent().add_child(fireball)
	get_tree().paused = false;
	visible = false;
	get_parent().get_parent().fireballLevel +=1
	
