extends Interactable


func _on_interacted(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		body.activate_double_jump()
		call_deferred("queue_free")
