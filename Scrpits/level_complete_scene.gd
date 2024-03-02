extends Node3D

@onready var timer_label = $UI/TimerLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	timer_label.text = GlobalTimer.time_text
	Checkpoints.reset_checkpoint()


func _on_restart_button_pressed():
	GlobalTimer.reset_timer()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_menu_button_pressed():
	GlobalTimer.reset_timer()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
