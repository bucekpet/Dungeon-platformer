extends AnimationPlayer


func _on_lever_interacted(body: Variant) -> void:
	play("Flip")
