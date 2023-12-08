extends Area2D

var enemy = preload("res://enemies/waveEnemy.tscn")
var speed = .6
@export var slant = Vector2.ZERO
var damage = 10
var player = null


func _ready():
	$Firewall.play()

func _process(delta):
#	if get_tree().get_nodes_in_group("waveMobs").size() < 400:
#		var enem = enemy.instantiate()
#		var vec = Vector2(randf_range(-1, 1)  * $CollisionShape2D.get_shape().get_size().x, randf_range(-1, 1) * $CollisionShape2D.get_shape().get_size().y)
#		vec = vec.rotated(0.523599)
#		enem.position = position + vec
#		add_child(enem)
	if player:
		player.take_damage(damage)
	position.x += speed *2
	position.y += -speed 
	slant = position + Vector2($CollisionShape2D.get_shape().get_size().x, $CollisionShape2D.get_shape().get_size().y)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		body.get_parent().take_damage(1000)
	if body.is_in_group("Player"):
		player = body 


func _on_body_exited(body):
	if body.is_in_group("waveMobs"):
		body.queue_free()
	if body.is_in_group("Player"):
		player = null
