extends CharacterBody2D

var speed = 120
var damage = 20
var health = 30
var dead = false
var player 
var ExpGem := preload("res://effects/ExpGem.tscn")
var healthOrb := preload("res://effects/healthOrb.tscn")
var sounds =[]


func _ready():
	sounds.append(preload("res://sounds/bones/1.ogg"))
	sounds.append(preload("res://sounds/bones/2.ogg"))
	sounds.append(preload("res://sounds/bones/3.ogg"))
	sounds.append(preload("res://sounds/bones/4.ogg"))
	sounds.append(preload("res://sounds/bones/5.ogg"))
	sounds.append(preload("res://sounds/bones/6.ogg"))
	sounds.append(preload("res://sounds/bones/7.ogg"))
	sounds.append(preload("res://sounds/bones/8.ogg"))
	sounds.append(preload("res://sounds/bones/9.ogg"))
	sounds.append(preload("res://sounds/bones/0.ogg"))



func _physics_process(delta):
	if !dead and player != null:
		if position.distance_to(player.position) > 5:
			velocity = (player.position -position).normalized() * speed
			move_and_slide()
#			if position != player.position:
#				position += (player.position - position ) / speed
			#$AnimatedSprite2D.play("skeleton ne")

			if (player.position.x - position.x) < 0:
				$skeleton.flip_h = false
			else:
				$skeleton.flip_h = true
			move_and_slide()
		if health <= 0:
			dead = true
			deathAnimation()
			collision_mask = 0
			collision_layer = 0
			z_index = -1
			sounds.shuffle()
			$AudioStreamPlayer.stream= sounds.front()
			$AudioStreamPlayer.play()
			var num = randi() % 10
			if num == 1:
				var exp = healthOrb.instantiate() 
				exp.position = position
				get_parent().add_child(exp)
			else:
				var exp = ExpGem.instantiate() 
				exp.position = position
				get_parent().add_child(exp)

func deathAnimation():
	$skeleton.play("dead")
	self.scale.x = 2.5
	self.scale.y = 2.5
	await get_tree().create_timer(2.0).timeout
	queue_free()

	
	
func _on_collisionarea_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)
		


func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body


func _on_collision_area_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)
