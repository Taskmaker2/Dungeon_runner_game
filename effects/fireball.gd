extends Node2D

var damage = 5
var wallDamage = 5
var speed = 10
var dead = false
var direct = Vector2()
var lookedAt = false
#@onready var tile_map : TileMap = $walls

func _ready():
	$comet.play()
	
	
	
func _process(delta):
	if !lookedAt:
		look_at(direct)
		lookedAt = true
	if !dead:
		position += speed * Vector2.RIGHT.rotated(rotation).normalized()
		#position.move_toward( direct, delta * speed )
	else: 
		$fireball.show()
		$comet/comet_collision.collision_mask = 0
		$comet.hide()
		$fireball/explosion.collision_mask = 1
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
func play():
	#get_tree().parent_scene.add_child(Sword)
	pass



func _on_comet_collision_body_entered(body):
	if body.is_in_group("mobs"):
		body.health -= damage
		$explosion_sound.play()
		dead = true
	if body.is_in_group("wall"):
		body.get_parent().take_damage(wallDamage)
		$explosion_sound.play()
		dead = true
	
			

func _on_explosion_body_entered(body):
	if body.is_in_group("mobs"):
		body.health -= damage
	if body.is_in_group("wall"):
		body.get_parent().take_damage(wallDamage)

