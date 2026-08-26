extends CharacterBody2D

# HOLY VARIABLES

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


# load in
func _ready() -> void:
	$FadeOut/AnimationPlayer.play("Fadein")

func _physics_process(delta: float) -> void:
	
	# very important code
	if 1+1 == 2:
		codeworking = true
	
	# =========================================
	# Player Physics and Movement
	# =========================================
	# GRAVITY
	if !locked:
		velocity.y += gravity * delta
	
	# MOVEMENT
	if Input.is_action_pressed("Left") and is_on_floor() and !dashing and !locked:
		PlayerFacing = 1
		velocity.x -= accel * delta
	if Input.is_action_pressed("Right") and is_on_floor() and !dashing and !locked:
		PlayerFacing = -1
		velocity.x += accel * delta
	if !Input.is_action_pressed("Left") and !Input.is_action_pressed("Right") and !dashing and !locked:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	if Input.is_action_pressed("Left") and !is_on_floor() and !dashing and !locked:
		PlayerFacing = 1
		velocity.x -= airfriction * delta
	if Input.is_action_pressed("Right") and !is_on_floor() and !dashing and !locked:
		PlayerFacing = -1
		velocity.x += airfriction * delta

	if is_on_wall():
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
		$CPUParticles2D3.emitting = false

	if Input.is_action_just_pressed("Interact"):
		position.x = 500
		position.y = -10000
# particle stuff
	if is_on_floor():
		if was_airborne:
			_on_landed() # Triggers exactly once upon impact
		was_airborne = false
	else:
		was_airborne = true
# void death
	if position.y >= 1500:
		die()

	if locked:
		velocity.x = 0
		velocity.y = 0

	var player_velocity = velocity
	move_and_slide()
	velocity.x = player_velocity.x
	
	if abs(velocity.x) > max_speed:
		velocity.x = sign(velocity.x) * max_speed
	print (velocity, PlayerFacing)
	print(codeworking)

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

#the code that kills you (it killed me making it lmao)
func die():
	locked = true
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	$DeathScreen.visible = true
	print($DeathScreen.visible)
	velocity.x = 0
	velocity.y = 0



# *if player hit ground then particle physics*
func _on_landed() -> void:
	$CPUParticles2D.emitting = true
	$CPUParticles2D2.emitting = true

# no way howd you do it
func _on_finish_line_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		print("YOU WIN!!!!!!!")
		win()

# congrats now go reward yourself with some https://www.youtube.com/watch?v=waKumDkYrDY specifically 1:56
func win():
	locked = true
	velocity.x = 0
	$FadeOut/AnimationPlayer.play("FadeOut")
	await get_tree().create_timer(1.5).timeout
	$FadeOut/Label.visible = true
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://Level2.tscn")

# aint no way bro you pressed the respawn button i should respawn you
func _on_button_button_down() -> void:
	get_tree().paused = false
	if locked:
		get_tree().reload_current_scene()
		print("button pressed", locked)
func _on_area_2d_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_2_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_3_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_4_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_5_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_6_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_7_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_8_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
func _on_spike_9_body_entered(body: Node2D) -> void:
	$Blood.emitting = true
	if body.name == "PlayerCharacter":
		print("you died lmao", body.name)
		die()
