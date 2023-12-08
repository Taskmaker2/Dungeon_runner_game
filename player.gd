extends CharacterBody2D

signal hit

@export var speed = 300 # How fast the player will move (pixels/sec).
@export var MAX_SPEED = 500
@export var ACCELERATION = 1500
@export var FRICTION = 1200
@export var EFFECTS = []
@export var health = 100
var buffer = true
var sword := preload("res://effects/effects.tscn")
@export var experience = 4
@export var experienceNeeded = 4

var screen_size # Size of the game window.
var canDash = true
var dashing = false
#var direction = Vector2.ZERO
var facing
@export var swordLevel = 0
@export var waveLevel = 0
@export var fireballLevel = 0

@onready var axis = Vector2.ZERO

func _ready():
	$SoldierSprite.play("walk_up_right")

func _physics_process(delta):
	move(delta)
#	for effect in EFFECTS:
#		effect.play() 
#	var Sword := sword.instantiate()
#	Sword.position = position
#	get_tree().current_scene.add_child(Sword)
#	#

func get_input_axis():
	axis.x = 2 * (int(Input.is_action_pressed("move_right")) -  int(Input.is_action_pressed("move_left")))
	axis.y = int(Input.is_action_pressed("move_down")) -  int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	
	if axis == Vector2.ZERO:
		velocity = Vector2.ZERO
		apply_friction(FRICTION * delta) # apply friction
	else:
		apply_movement(axis *ACCELERATION * delta) #apply movement
	
	if Input.is_action_just_pressed("dash") and canDash:
		velocity = axis.normalized() * 1000
		dashing = true
		await get_tree().create_timer(0.8).timeout
		canDash = false
		#velocity *= 1.0 -(FRICTION *delta) #slowing down after dashing
		$dash_cooldown.start()	
		
	if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		$SoldierSprite.play()
	else:
		$SoldierSprite.stop()
		$SoldierSprite.frame = 3
	
	if velocity.y > 0:
		$SoldierSprite.animation = "walk_down_left"
	elif velocity.y < 0:
		$SoldierSprite.animation = "walk_up_right"

	if velocity.x != 0:
		if velocity.x < 0:
			$SoldierSprite.flip_h = true
		else:
			$SoldierSprite.flip_h = false
		# See the note below about boolean assignment.
		$SoldierSprite.flip_h = velocity.x < 0

	move_and_slide()
	
	if experience >= experienceNeeded:
		experience -= experienceNeeded
		experienceNeeded = int(1.5 * experienceNeeded)
		get_tree().paused = true
		$CanvasLayer/levelUp.visible = true
		$levelupsound.play()
		

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
	
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)


#func _process(delta):
#	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("left"))
#	if Input.is_action_pressed("move_right"):
#		velocity.x += 2
#	if Input.is_action_pressed("move_left"):
#		velocity.x -= 2  
#	if Input.is_action_pressed("move_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("move_up"):
#		velocity.y -= 1

	#position += velocity * delta

	#position = position.clamp(Vector2.ZERO, screen_size)
	

	#move_and_slide()


func send_hit():
	#if body is RigidBody2D:
		#hide() # Player disappears after being hit.
	hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		#$CollisionShape2D.set_deferred("disabled", true)
		
func start(pos):
	position = pos
	show()
	#$RigidBody2D/CollisionShape2D.disabled = false
	
func win():
		get_tree().paused = true
		$CanvasLayer/win.visible = true
		$CanvasLayer/levelUp.visible = false

func take_damage(damage):
	if buffer: 
		health -= damage
		buffer = false
		$damage_cooldown.start()
		$SoldierSprite.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$SoldierSprite.modulate = Color.WHITE
		$hurt.play()
	if health <= 0:
		$SoldierSprite.play("dead")
		
		
func _on_dash_cooldown_timeout():
	dashing = false
	canDash = true


func _on_damage_cooldown_timeout():
	buffer = true

func playExpSound():
	$expSound.play()
