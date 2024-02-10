extends Interactable

func _on_interacted(body):
	Abilities.activate_ability('sprint')
	call_deferred("queue_free")
