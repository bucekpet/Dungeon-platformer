extends Interactable

func _on_interacted(body: CharacterBody3D):
	if body.is_in_group("Player"):
		body.activate_sprint()
		call_deferred("queue_free")
