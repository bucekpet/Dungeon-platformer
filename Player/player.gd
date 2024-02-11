extends CharacterBody3D

@export_group('Input names')
@export var input_back_name := "move_backward"
@export var input_forward_name := "move_forward"
@export var input_left_name := "move_left"
@export var input_right_name := "move_right"
@export var input_sprint_name := "move_sprint"
@export var input_jump_name := "move_jump"

@export_group("Abilities activation")
@export var movement_activated := true
@export var sprint_activated := true
@export var jump_activated := true
@export var double_jump_activated := true

@export_group("Movement")
@export_range(-10, 10, 0.5) var gravity_multiplier := 3.0
@export_range(0, 20, 0.5) var speed := 5.0
@export_range(-20, 20, 0.5) var acceleration := 8.0
@export_range(-20, 20, 0.5) var deceleration := 10.0
@export_range(0, 1, 0.1) var air_control := 0.3

@export_group("Sprint")
@export_range(0, 3, 0.1) var sprint_speed_multiplier := 1.6

@export_group("Jump")
@export_range(0, 20, 0.5) var jump_height := 10.0
@export_range(0, 1, 0.05) var coyote_time := 0.15
@export_range(0, 20, 0.5) var second_jump_height := 10.0

@export_group("Stamina")
@export_range(0, 500, 10) var recovery_rate := 200.0
@export_range(0, 100, 1) var jump_cost := 33.0
@export_range(0, 500, 10) var sprint_cost := 100.0

@export_group("Mouse")
@export_range(0, 10, 0.05) var mouse_sensitivity := 2.0
@export var vertical_angle_limit := 90.0

@export_group("Camera FOV")
@export var min_fov := 75
@export var max_fov := 90
@export_range(0, 10, 0.1) var delta_fov := 3.0

@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
@onready var head: Marker3D = $Head
@onready var coyote_timer: Timer = $"Coyote timer"
@onready var camera_3d = $Head/Camera3D
@onready var stamina_bar: TextureProgressBar = $"UI/Stamina bar"

var _rotation := Vector2.ZERO
var speed_multiplier := 1.0
var can_jump := true
var can_double_jump := false
var stamina := 100

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	vertical_angle_limit = deg_to_rad(vertical_angle_limit)
	coyote_timer.wait_time = coyote_time

func _input(event: InputEvent) -> void:
	## Mouse input if mouse is captured
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.relative)

func _process(delta: float) -> void:
	stamina_bar.value = stamina
	if stamina_bar.value >= 100:
		stamina_bar.visible = false
	else:
		stamina_bar.visible = true

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_vector(input_back_name, input_forward_name, input_left_name, input_right_name)
	var input_sprint = Input.is_action_pressed(input_sprint_name)
	var input_jump = Input.is_action_just_pressed(input_jump_name)
	
	if movement_activated:		handle_movement(input_axis, delta)
	if sprint_activated: 		handle_sprint(input_sprint, delta); handle_camera_fov(input_sprint, delta)
	if jump_activated:			handle_jump(input_jump, delta)
	if double_jump_activated: 	handle_double_jump(input_jump)

	move_and_slide()
	
func rotate_head(mouse_axis: Vector2) -> void:
	## Horizontal rotation
	_rotation.y -= mouse_axis.x * (mouse_sensitivity/1000)
	## Vertical rotation
	_rotation.x = clamp(_rotation.x - mouse_axis.y * (mouse_sensitivity/1000), -vertical_angle_limit, vertical_angle_limit)
	
	rotation.y = _rotation.y
	head.rotation.x = _rotation.x

func handle_movement(input_axis: Vector2, delta: float) -> void:
	var direction = Vector3()
	var aim = self.get_global_transform().basis
	
	if input_axis.x >= 0.5:
		direction -= aim.z
	if input_axis.x <= -0.5:
		direction += aim.z
	if input_axis.y <= -0.5:
		direction -= aim.x
	if input_axis.y >= 0.5:
		direction += aim.x
	else:
		direction.y = 0
	
	direction = direction.normalized()
	
	## Temporary variables
	var temp_vel := velocity
	temp_vel.y = 0
	var temp_accel: float
	var target: Vector3 = direction.normalized() * speed * speed_multiplier
	
	## Acceleration / deceleration
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	## Air friction
	if not is_on_floor:
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

func handle_head_lean(delta: float) -> void:
	pass

func handle_sprint(input_sprint: bool, delta: float) -> void:
	if input_sprint:
		speed_multiplier = sprint_speed_multiplier
		change_stamina(-sprint_cost * delta)
	else:
		speed_multiplier = 1.0

func handle_camera_fov(input_sprint: bool, delta: float) -> void:
	var target:float = max_fov if input_sprint else min_fov
	camera_3d.fov = lerp(camera_3d.fov, target, delta_fov * delta)

func handle_jump(input_jump: bool, delta: float) -> void:
	if is_on_floor():
		can_jump = true
		can_double_jump = false
	elif can_jump and coyote_timer.is_stopped():
		coyote_timer.start()
	else:
		velocity.y -= gravity * delta
	
	## Jump
	if input_jump and can_jump and stamina > 0:
		can_jump = false
		can_double_jump = true
		change_stamina(-jump_cost)
		velocity.y = jump_height
	
func _on_coyote_timer_timeout() -> void:
	can_jump = false
	can_double_jump = true

func handle_double_jump(input_jump: bool) -> void:
	if input_jump and not is_on_floor() and can_double_jump and stamina > 0:
		can_double_jump = false
		change_stamina(-jump_cost)
		velocity.y = second_jump_height

func change_stamina(amount: float) -> void:
	stamina = clamp(stamina + amount, 0 , 100)

func die() -> void:
	position = Checkpoints.checkpoint

func _on_hurtbox_body_entered(body: Node3D) -> void:
	die()

func _on_hurtbox_area_entered(area: Area3D) -> void:
	die()
