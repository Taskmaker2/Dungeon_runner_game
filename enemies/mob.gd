
extends RigidBody2D
var move_speed = 50
var speed: float = 0.1 # put wanted speed here


func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	#$AnimatedSprite2D.animation = "default"
	
#deletes when off screen - need to change
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
	
func _process(delta):
	#global_position = global_position.move_toward($player.get_global_position(), move_speed *delta)
	#look_at(player.global_position)
	#self.position = lerp(self.position,player.global_position,speed)
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.send_hit()
