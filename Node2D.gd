extends Node2D
var ExpGem := preload("res://effects/ExpGem.tscn")
var healthOrb := preload("res://effects/healthOrb.tscn")

func _ready():
	$AnimatedSprite2D.play("closed")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("open")
		for i in 5:
			var exp = ExpGem.instantiate() 
			exp.position = position
			get_parent().add_child(exp)
		var health = healthOrb.instantiate()
		health.position = position
		get_parent().add_child(health)
		$Area2D.collision_layer = 0
		$Area2D.collision_mask = 0
