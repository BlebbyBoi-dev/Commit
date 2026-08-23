extends CharacterBody2D

var gravity = 400
var accel = 500
var jump_power = -20000
var max_speed = 1000
var dashpower = 700
var PlayerFacing = 0
var dashing = false
var codeworking = false

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
	
func backstep(): #backstep yippee
	dashing = true
	velocity.x = dashpower * PlayerFacing
	move_and_slide()
