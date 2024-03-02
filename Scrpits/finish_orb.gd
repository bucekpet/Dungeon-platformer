extends Interactable

func _on_interacted(body):
	GlobalTimer.stop_timer()
	get_tree().change_scene_to_file("res://Scenes/level_complete_scene.tscn")
