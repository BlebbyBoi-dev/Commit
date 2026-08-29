extends Control

var creditsdone = false
var fade_speed = 0.6

func _ready() -> void:
	$"../Screenshot20260829202025".modulate.a = 0.0
	await get_tree().create_timer(38).timeout
	creditsdone = true
	if creditsdone:
		print("credits done") # this works

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= 1
	if creditsdone:
		$"../Screenshot20260829202025".modulate.a += fade_speed * delta
		$"../Screenshot20260829202025".modulate.a = min($"../Screenshot20260829202025".modulate.a, 1.0)
	print($"../Screenshot20260829202025".modulate.a) #shhhhhhhhhhh secret spoiler
	# did someone say a chapter 2??
