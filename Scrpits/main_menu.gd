extends Node3D

@onready var options_menu: VBoxContainer = $"Menu UI/Options Menu"
@onready var resolution_option_button: OptionButton = $"Menu UI/Options Menu/ResolutionOptionButton"

const Resolutions: Dictionary = {"1920x1080":Vector2(1920,1080),
								"1366x768":Vector2(1366,768),
								"1536x864":Vector2(1536,864),
								"1280x720":Vector2(1280,720),
								"1440x900":Vector2(1440,900),
								"1600x900":Vector2(1600,900),
								"1024x600":Vector2(1024,600),
								"800x600": Vector2(800,600)}

func _ready() -> void:
	options_menu.visible = false
	
	for res in Resolutions:
		resolution_option_button.add_item(res)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_reset_button_pressed() -> void:
	GlobalTimer.reset_best_time()
