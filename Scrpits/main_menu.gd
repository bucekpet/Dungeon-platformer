extends Node3D

@onready var options_button: Button = $"Menu UI/Main menu/OptionsButton"
@onready var options_menu: VBoxContainer = $"Menu UI/Options Menu"
@onready var resolution_option_button: OptionButton = $"Menu UI/Options Menu/ResolutionOptionButton"
@onready var window_mode_button: OptionButton = $"Menu UI/Options Menu/WindowModeButton"

const Resolutions: Dictionary = {"1920x1080":Vector2(1920,1080),
								"1366x768":Vector2(1366,768),
								"1536x864":Vector2(1536,864),
								"1280x720":Vector2(1280,720),
								"1440x900":Vector2(1440,900),
								"1600x900":Vector2(1600,900),
								"1024x600":Vector2(1024,600),
								"800x600": Vector2(800,600)}

const WindowModes: Array[String] = [
	"Fullscreen",
	"Windowed",
]

func _ready() -> void:
	options_menu.visible = false
	options_button.toggle_mode = true
	
	## Add resolutions and modes to the option buttons
	for res in Resolutions:
		resolution_option_button.add_item(res)
	for mode in WindowModes:
		window_mode_button.add_item(mode)
	

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_reset_button_pressed() -> void:
	GlobalTimer.reset_best_time()


func _on_options_button_toggled(toggled_on: bool) -> void:
	options_menu.visible = toggled_on



func _on_resolution_option_button_item_selected(index: int) -> void:
	var res_size = Resolutions.get(resolution_option_button.get_item_text(index))
	DisplayServer.window_set_size(res_size)


func _on_window_mode_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
