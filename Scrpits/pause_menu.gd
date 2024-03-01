extends Control

@onready var player = $"../.."


func _on_resume_button_pressed():
	player.unpause_game()

func _on_restart_button_pressed():
	Engine.time_scale = 1
	get_tree().call_deferred('reload_current_scene')

func _on_menu_button_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
