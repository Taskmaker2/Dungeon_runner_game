extends Node2D

@export var mob_scene: PackedScene
var score = 0;
var playerHealth = 0;

func _process(delta):
	if $Player.health <= 0:
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
	$HUD.update_health($Player.health)
#
#func _on_player_hit():
#	if playerHealth <= 0:
#		$ScoreTimer.stop()
#		$MobTimer.stop()
#		$HUD.show_game_over()
#	else: 
#		playerHealth -= 1;
#		$HUD.update_health(playerHealth)
#
func new_game():
	score = 0
	playerHealth = 100;
	$HUD.update_health(playerHealth)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$MobTimer.start()
	$ScoreTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	
func _on_score_timer_timeout():
	#score += 1
	$HUD.update_score($Player.experience)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("Player/MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = $Player/MobPath/MobSpawnLocation.global_position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

