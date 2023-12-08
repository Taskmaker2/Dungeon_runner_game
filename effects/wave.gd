extends Node2D

var damage = 2
var wallDamage = 2
var speed = 7
var cast = false
var size = 15
#@onready var tile_map : TileMap = $walls


func _on_area_2d_body_entered(body):
	if body.is_in_group("mobs"):
		body.health -= damage
		if !body.is_in_group("boss"):
			body.velocity = (body.position - get_parent().position).normalized() * 400
			for i in 10:
				body.move_and_slide()
	if body.is_in_group("wall"):
		body.get_parent().take_damage(wallDamage)
			

func _process(delta):
	rotate(delta * speed)
	if scale.x < size:
		if scale.x < .2:
			scale.x += .5
			scale.y += .5
		else:
			scale.x += .25
			scale.y += .25
	else:
		hide()
		cast = true
		$Wave/Area2D.collision_mask = 0
		$cast_time.wait_time = 3

	

func play():
	#get_tree().parent_scene.add_child(Sword)
	pass


func _on_cast_time_timeout():
	if cast:
		cast = false
		show()
		$Wave/Area2D.collision_mask = 1
		$cast_time.wait_time = 3.0
		scale.x = 0
		scale.y = 0



func _on_area_2d_2_body_entered(body):
	pass # Replace with function body.
