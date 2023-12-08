extends Node2D

@onready var fireball = load("res://effects/fireball.tscn")
var cast = false
var nearest = null

func _on_cast_time_timeout():
	var fire = fireball.instantiate()
	get_parent().get_parent().add_child(fire)
	if nearest != null:
		fire.direct = nearest.position
		fire.position = get_parent().position
	else:
		var pos = Vector2(randf(),randf()) 
		fire.direct = pos
		fire.look_at(pos)
		fire.position = get_parent().position


func _on_target_area_body_entered(body):
	if body.is_in_group("mobs"):
		if nearest != null:
			if (position.distance_to(body.position)) < (position.distance_to(nearest.position)):
				nearest = body
		else:
			nearest = body
