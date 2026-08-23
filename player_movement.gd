extends CharacterBody2D

var gravity = 400
var accel = 500
var jump_power = -20000
var max_speed = 1000
var dir = 0

func _physics_process(delta: float) -> void:
	# GRAVITY
	velocity.y += gravity * delta

	# MOVEMENT
	if Input.is_action_pressed("Left") and is_on_floor():
		velocity.x += accel * delta * -1
	if Input.is_action_just_released("Left"):
		velocity.x = 0
	
	if Input.is_action_pressed("Right") and is_on_floor():
		velocity.x += accel * delta
	if Input.is_action_just_released("Right"):
		velocity.x = 0

	if velocity.x <= -1 * max_speed:
		velocity.x = -1 * max_speed
	elif velocity.x >= 1 * max_speed:
		velocity.x = 1 * max_speed

	# JUMP
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += jump_power * delta
	

	
	
	move_and_slide()
	print (velocity, dir)
