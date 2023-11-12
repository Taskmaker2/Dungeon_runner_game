extends Node2D

var health = 30

func take_damage(damage):
	health -= damage
	if health <= 0:
		$AnimatedSprite2D.frame = 3
		$collisionBox.collision_layer = 0
		$collisionBox.collision_mask = 0
	elif health <= 10:
		$AnimatedSprite2D.frame = 2
	elif health <= 20:
		$AnimatedSprite2D.frame = 1
		
