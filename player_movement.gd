extends CharacterBody2D

var gravity = 400
var accel = 500
var jump_power = -20000
var max_speed = 1000
var dashpower = 1200
var PlayerFacing = "right"
var dashing = false

func _physics_process(delta: float) -> void:
	# GRAVITY
	velocity.y += gravity * delta

	# MOVEMENT
	if Input.is_action_pressed("Left") and is_on_floor():
		velocity.x += accel * delta * -1
		dashing = false
	elif Input.is_action_pressed("Right") and !is_on_floor():
		dashing = true
	if Input.is_action_just_released("Left"):
		velocity.x = 0
	
	if Input.is_action_pressed("Right") and is_on_floor():
		velocity.x += accel * delta
		dashing = false
	elif Input.is_action_pressed("Right") and !is_on_floor():
		dashing = true
	if Input.is_action_just_released("Right"):
		velocity.x = 0

	if velocity.x <= -1 * max_speed:
		velocity.x = -1 * max_speed
	elif velocity.x >= 1 * max_speed:
		velocity.x = 1 * max_speed

	# JUMP
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += jump_power * delta
	
	# BACKSTEP
	# Get the direction that the player is facing
	if Input.is_action_pressed("Right"):
		PlayerFacing = "right"
	elif Input.is_action_pressed("Left"):
		PlayerFacing = "left"
	
	# Launch the player backward
	if Input.is_action_just_pressed("Dash") and PlayerFacing == "right":
		velocity.x = dashpower * -1
		dashing = true
		
	if velocity.x < 0 and dashing == true:
		velocity.x += 50
	
	if Input.is_action_just_pressed("Dash") and PlayerFacing == "left":
		velocity.x = dashpower
		dashing = true
		
	if velocity.x > 0 and dashing == true:
		velocity.x -= 50
	
	
	move_and_slide()
	print (velocity, PlayerFacing)
