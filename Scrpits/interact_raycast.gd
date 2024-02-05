extends RayCast3D


func _ready() -> void:
	add_exception(owner)

func _physics_process(delta: float) -> void:
	if is_colliding():
		var detected := get_collider()
		
		if detected is Interactable:
			if Input.is_action_just_pressed("interact"):
				detected.interact(owner)
