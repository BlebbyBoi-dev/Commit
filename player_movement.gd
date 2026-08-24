extends CharacterBody2D

@export var gravity = 400
@export var accel = 500
@export var jump_power = -20000
@export var max_speed = 1000
@export var dashpower = 700
@export var PlayerFacing = 0
@export var dashing = false
@export var codeworking = false
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# very important code
	if 1+1 == 2:
		codeworking = true
	
	# GRAVITY
	velocity.y += gravity * delta

	# MOVEMENT
	if Input.is_action_pressed("Left") and is_on_floor() and !dashing:
		PlayerFacing = 1
		velocity.x += accel * delta * -1
	if Input.is_action_just_released("Left") and !dashing:
		velocity.x = 0
	
	if Input.is_action_pressed("Right") and is_on_floor() and !dashing:
		PlayerFacing = -1
		velocity.x += accel * delta
	if Input.is_action_just_released("Right") and !dashing:
		velocity.x = 0

	if velocity.x <= -1 * max_speed:
		velocity.x = -1 * max_speed
	elif velocity.x >= 1 * max_speed:
		velocity.x = 1 * max_speed

	# JUMP
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += jump_power * delta
	
	# CALL BACKSTEP
	if Input.is_action_just_pressed("Dash") and !dashing:
		backstep()
	# Decay backstep
	if velocity.x < 0 and dashing: 
		velocity.x += 20
	if velocity.x > 0 and dashing: 
		velocity.x -= 20
	if velocity.x == 0:
		dashing = false

	move_and_slide()
	print (velocity, PlayerFacing)
	
	# Anims
	if PlayerFacing == 1:
		$AnimatedSprite2D.flip_h = true
	elif PlayerFacing == -1:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
	elif velocity.x > -500 and velocity.x < 500 and !dashing:
		$AnimatedSprite2D.play("Walking")
	elif velocity.x > 500 or velocity.x < -500 and !dashing:
		$AnimatedSprite2D.play("Running")
	if velocity.y > 0:
		$AnimatedSprite2D.play("FallLand")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("Jump")
	if dashing and !is_on_floor():
		$AnimatedSprite2D.play("Backstep")
	elif dashing and is_on_floor():
		$AnimatedSprite2D.play("Backstep Land")
	
	# get anim
	var current_anim = sprite.animation
	if sprite.is_playing():
		print("Playing: ", current_anim)
	else:
		print("Stopped on: ", current_anim)
		
func backstep(): #backstep yippee
	dashing = true
	velocity.x = dashpower * PlayerFacing
	move_and_slide()
