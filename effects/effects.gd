extends Node2D

var damage = 10
var wallDamage = 5
var speed = 8
var cast = false
#@onready var tile_map : TileMap = $walls


func _on_area_2d_body_entered(body):
	if body.is_in_group("mobs"):
		body.health -= damage
	if body.is_in_group("wall"):
		body.get_parent().take_damage(wallDamage)
			

func _process(delta):
	rotate(delta * speed)
	

func play():
	#get_tree().parent_scene.add_child(Sword)
	pass


func _on_cast_time_timeout():
	if cast:
		cast = false
		show()
		$sword/Area2D.collision_mask = 1
	else: 
		hide()
		cast = true
		$sword/Area2D.collision_mask = 0

