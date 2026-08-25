extends Node2D

@export var log_spacing = 64.0

func _ready():
	var logs = get_children()

	for i in range(logs.size() - 1):
		var log_a = logs[i]
		var log_b = logs[i + 1]

		var joint = PinJoint2D.new()

		joint.node_a = log_a.get_path()
		joint.node_b = log_b.get_path()

		joint.position = (log_a.position + log_b.position) / 2

		add_child(joint)

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
				$Log1.set_deferred("freeze", false)
