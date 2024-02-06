extends Node

var checkpoint: Vector3 = Vector3(0, 1, 0)

func update_checkpoint(new_checkpoint: Vector3) -> void:
	checkpoint = new_checkpoint + Vector3(0, 1, 0)

func reset_checkpoint() -> void:
	checkpoint = Vector3(0, 1, 0)
