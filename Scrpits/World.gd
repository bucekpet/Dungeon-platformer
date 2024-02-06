extends Node3D

var player: CharacterBody3D

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		if event.keycode == KEY_TAB:
			Checkpoints.reset_checkpoint()
			get_tree().reload_current_scene()

#func _ready() -> void:
	#player = get_tree().get_first_node_in_group('Player')
	#
	#player.position = Checkpoints.checkpoint
