extends Area3D

var player: CharacterBody3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	var theta := atan2(position.x - player.position.x, position.z - player.position.z)
	set_rotation(Vector3(0, theta, 0))
