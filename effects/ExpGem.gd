extends Node2D

var speed = 80
var player_chase = false
var player = null
var value = 1
var velocity = Vector2()
var pickup = true
var maxSpeed = 500
var minSpeed = 0

func _physics_process(delta):
	self.translate(velocity * delta)
	if player_chase:
		if position.distance_to(player.position) > 5:
			velocity = (player.position -position).normalized() * speed
			self.translate(velocity * delta)
			speed += 2

func _on_collection_range_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		$chasetimer.start()
		if pickup: 
			velocity = Vector2(randf_range(-600, 600), randf_range(-600, 600))
			pickup = false


func _on_pickup_range_body_entered(body):
	if body.is_in_group("Player"):
		body.experience += value
		queue_free()


func _on_chasetimer_timeout():
		player_chase = true
