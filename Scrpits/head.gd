extends Marker3D

@export var mouse_sensitivity := 2.0
@export var vertical_angle_limit := 90.0

var actual_rotation := Vector3()

func _ready() -> void:
	actual_rotation.y = get_owner().rotation.y
	vertical_angle_limit = deg_to_rad(vertical_angle_limit)


func rotate_camera(mouse_axis : Vector2) -> void:
	# Horizontal mouse look.
	actual_rotation.y -= mouse_axis.x * (mouse_sensitivity/1000)
	# Vertical mouse look.
	actual_rotation.x = clamp(actual_rotation.x - mouse_axis.y * (mouse_sensitivity/1000), -vertical_angle_limit, vertical_angle_limit)
	
	get_owner().rotation.y = actual_rotation.y
	rotation.x = actual_rotation.x
