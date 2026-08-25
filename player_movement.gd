extends CharacterBody2D

@export var gravity = 400
@export var accel = 500
@export var jump_power = -20000
@export var max_speed = 1000
@export var dashpower = 700
@export var PlayerFacing = 0
@export var dashing = false
@export var codeworking = false
@export var friction = 100
@export var airfriction = 100
@export var was_airborne = false
@export var locked = false
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	# very important code
	if 1+1 == 2:
		codeworking = true
	
	# GRAVITY
	if !locked:
		velocity.y += gravity * delta
	
	# MOVEMENT
	if Input.is_action_pressed("Left") and is_on_floor() and !dashing and !locked:
		PlayerFacing = 1
		velocity.x += accel * delta * -1
	if Input.is_action_pressed("Right") and is_on_floor() and !dashing and !locked:
		PlayerFacing = -1
		velocity.x += accel * delta
	if !Input.is_action_pressed("Left") and !Input.is_action_pressed("Right") and !dashing and !locked:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	if Input.is_action_pressed("Left") and !is_on_floor() and !dashing and !locked:
		PlayerFacing = 1
		velocity.x += airfriction * delta * -1
	if Input.is_action_pressed("Right") and !is_on_floor() and !dashing and !locked:
		PlayerFacing = -1
		velocity.x += airfriction * delta

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
		$CPUParticles2D3.emitting = false

# particle stuff
	if is_on_floor():
		if was_airborne:
			_on_landed() # Triggers exactly once upon impact
		was_airborne = false
	else:
		was_airborne = true
# void death
	if position.y >= 1000:
		die()

	if locked:
		velocity.x = 0
		velocity.y = 0


	move_and_slide()
	print (velocity, PlayerFacing)
	
	# Anims
	if PlayerFacing == 1:
		$AnimatedSprite2D.flip_h = true
	elif PlayerFacing == -1:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.x == 0:
		$AnimatedSprite2D.play("Idle")
	elif velocity.x > -500 and velocity.x < 500 and !dashing and !is_on_wall():
		$AnimatedSprite2D.play("Walking")
	elif velocity.x > 500 or velocity.x < -500 and !dashing and !is_on_wall():
		$AnimatedSprite2D.play("Running")
	if velocity.y > 0 and !is_on_wall():
		$AnimatedSprite2D.play("FallLand")
	elif velocity.y < 0 and !is_on_wall():
		$AnimatedSprite2D.play("Jump")
	if dashing and !is_on_floor() and !is_on_wall():
		$AnimatedSprite2D.play("Backstep")
	elif dashing and is_on_floor() and !is_on_wall():
		$AnimatedSprite2D.play("Backstep Land")
	
	# get anim
	var current_anim = sprite.animation
	if sprite.is_playing():
		print("Playing: ", current_anim)
	else:
		print("Stopped on: ", current_anim)
		
func backstep(): #backstep yippee
	dashing = true
	if dashing:
		$CPUParticles2D3.emitting = true
	velocity.x = dashpower * PlayerFacing
	move_and_slide()


func _on_spike_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
	
func die():
	locked = true
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	$DeathScreen.visible = true
	print($DeathScreen.visible)
	velocity.x = 0
	velocity.y = 0

func _on_landed() -> void:
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true


func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		print("YOU WIN!!!!!!!")
		win()
		
func win():
	locked = true
	velocity.x = 0
	$FadeOut/AnimationPlayer.play("FadeOut")
	await get_tree().create_timer(1.5).timeout
	$FadeOut/Label.visible = true
	


func _on_button_button_down() -> void:
	get_tree().paused = false
	if locked:
		get_tree().reload_current_scene()
		print("button pressed", locked)
