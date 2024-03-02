extends Node3D

@onready var options_menu: VBoxContainer = $"Menu UI/Options Menu"

func _ready() -> void:
	options_menu.visible = false

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_reset_button_pressed() -> void:
	GlobalTimer.reset_best_time()
