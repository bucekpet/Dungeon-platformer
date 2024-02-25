extends Area3D

var player: CharacterBody3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	look_at(player.position, Vector3(0, 1, 0), false)
