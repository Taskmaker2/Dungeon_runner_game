extends CharacterBody2D

var speed = 90
var damage = 20
var health = 1500  #3000
var dead = false
var player = null
var ExpGem := preload("res://effects/ExpGem.tscn")
var specialAttack = false
var charging = false
var Minions := preload("res://boss_minion.tscn")

#func _ready():
#	specialAttacks.append(func SummonMinions():)
#	specialAttacks.append(func charge():)

func _physics_process(delta):
	if !dead and !specialAttack and player != null:
		if position.distance_to(player.position) > 5:
			velocity = (player.position -position).normalized() * speed
			move_and_slide()
#			if position != player.position:
#				position += (player.position - position ) / speed
			#$AnimatedSprite2D.play("skeleton ne")
			if (player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			move_and_slide()
		if health <= 0:
#			$AnimatedSprite2D.play("dead")
			dead = true
			$collisionarea.collision_mask = 0
			$collisionarea.collision_layer = 0
			z_index = -1
			for i in 30:
				var exp = ExpGem.instantiate() 
				exp.position = position + Vector2(randf_range(-5,5), randf_range(-5,5))
				get_parent().add_child(exp)
			deathAnimation()
	elif charging:		
			move_and_slide()

func deathAnimation():
	for i in 20:
		$AnimatedSprite2D.modulate = Color.RED
		await get_tree().create_timer(.3 - (i*.05)).timeout
		$AnimatedSprite2D.modulate = Color.WHITE
	await get_tree().create_timer(2.0).timeout	
	player.win()
	
	
func _on_collisionarea_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)
		

func shake():
	position.y += 5
	await get_tree().create_timer(0.1).timeout
	position.y -= 5
	await get_tree().create_timer(0.1).timeout
	position.y += 5
	await get_tree().create_timer(0.1).timeout
	position.y -= 5
	await get_tree().create_timer(0.1).timeout
	position.y += 5
	await get_tree().create_timer(0.1).timeout
	position.y -= 5
	await get_tree().create_timer(0.1).timeout
	position.y += 5
	await get_tree().create_timer(0.1).timeout
	position.y -= 5
	await get_tree().create_timer(0.1).timeout
	position.y += 5
	await get_tree().create_timer(0.1).timeout
	position.y -= 5
	await get_tree().create_timer(0.1).timeout

func SummonMinions():
	var offset = 120
	var minion1 = Minions.instantiate()
	minion1.position = position
	minion1.position.x += offset
	minion1.player = player
	get_parent().add_child(minion1)
	var minion2 = Minions.instantiate()
	minion2.position = position
	minion2.position.x -= offset
	minion2.player = player
	get_parent().add_child(minion2)
	var minion3 = Minions.instantiate()
	minion3.position = position
	minion3.position.y += offset
	minion3.player = player
	get_parent().add_child(minion3)
	var minion4 = Minions.instantiate()
	minion4.position = position
	minion4.position.y -= offset
	minion4.player = player
	get_parent().add_child(minion4)
	await get_tree().create_timer(3.0).timeout
	specialAttack = false
	$special_attack_timer.wait_time = 12

func charge():

	for i in 2:
		shake()
		await get_tree().create_timer(1.0).timeout
		velocity = (player.position -position).normalized() * speed * 10
		charging = true
		collision_mask = 0
		await get_tree().create_timer(0.8).timeout
		charging = false
		collision_mask = 1

	specialAttack = false
	$special_attack_timer.wait_time = 12

func _on_special_attack_timer_timeout():
	if !dead:
		specialAttack = true
		var attackNum = randi() % 2
		if attackNum == 0:
			SummonMinions()
		elif attackNum == 1:
			charge()

	


func _on_detect_player_body_entered(body):
	if body.is_in_group("Player"):
		player = body
