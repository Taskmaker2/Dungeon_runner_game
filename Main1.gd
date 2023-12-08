extends Node2D

@export var mob_scene: PackedScene
var score = 0;
var playerHealth = 0;
var waveEnemy = preload("res://enemies/waveEnemy.tscn")
var Boss = preload("res://boss.tscn")
@export var slant = Vector2.ZERO

func _ready():
	get_tree().paused = true
	

func _process(delta):
	if $Player.health <= 0:
		$ScoreTimer.stop()
		$MobTimer.stop()
		$HUD.show_game_over()
		get_tree().paused = true
	$HUD.update_health($Player.health)
	if Input.is_action_just_pressed("Pause"):
		$CanvasLayer/Pause_Menu.visible = true;
		get_tree().paused = true

		

#	if get_tree().get_nodes_in_group("waveMobs").size() < 400:
#		var enem = waveEnemy.instantiate()
#		print($WallOfDeath.position)
#		var vec = Vector2(randf_range(-1, 1)  * ($WallOfDeath.get_node("CollisionShape2D").get_shape().get_size().x / 2), 
#		randf_range(-1,1) * ($WallOfDeath.get_node("CollisionShape2D").get_shape().get_size().y / 2))
#		vec = vec.rotated(0.523599)
#		enem.position = ($WallOfDeath.get_node("CollisionShape2D").position + vec)
#		#enem.velocity = $WallOfDeath.get_node("CollisionShape2D").position
#		add_child(enem)

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
	get_tree().paused = false
	
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

func _on_area_2d_area_entered(area):
	if area.is_in_group("wallofdeath"):
		area.speed = 0.0


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and get_tree().get_nodes_in_group("boss").size() == 0:
		var boss = Boss.instantiate()
		add_child(boss)
		boss.position = $BossPosition.position
		boss.player = body
		$DungeonMusic.stop()
		$BossMusic.play()
		$MobTimer.wait_time = 200
