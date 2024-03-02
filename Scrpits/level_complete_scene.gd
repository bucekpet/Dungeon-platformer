extends Node3D

@onready var timer_value: Label = $UI/TimerValue
@onready var best_time_value: Label = $UI/BestTimeValue

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Checkpoints.reset_checkpoint()
	GlobalTimer.save_best()
	timer_value.text = GlobalTimer.convert_time(GlobalTimer.time)
	best_time_value.text = GlobalTimer.convert_time(GlobalTimer.best_time)


func _on_restart_button_pressed():
	GlobalTimer.reset_timer()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_menu_button_pressed():
	GlobalTimer.reset_timer()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
