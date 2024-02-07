extends CharacterBody3D

@onready var head: Marker3D = $Head
@onready var head_check: RayCast3D = $"Head Check"
@onready var stamina_bar: TextureProgressBar = $"UI/Stamina bar"

@export_group("Movement")
@export var gravity_multiplier := 3.0
@export var speed := 10
@export var acceleration := 8
@export var deceleration := 10
@export var air_control := 0.3

@export_group("Sprint")
@export var sprint_speed_multiplier := 1.6

@export_group("Jump")
@export var jump_height := 10

@export_group("Stamina")
@export var depletion_rate := 100
@export var recovery_rate := 200

var input_back_name := "move_backward"
var input_forward_name:= "move_forward"
var input_left_name := "move_left"
var input_right_name := "move_right"
var input_sprint_name := "move_sprint"
var input_jump_name := "move_jump"
var _direction: Vector3
var stamina := 100
var can_sprint := true

@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	stamina_bar.value = stamina
	if stamina_bar.value >= 100:
		stamina_bar.visible = false
	else:
		stamina_bar.visible = true

func _physics_process(delta):
	var valid_input := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if valid_input:
		var input_axis = Input.get_vector(input_back_name, input_forward_name, input_left_name, input_right_name)
		var input_jump = Input.is_action_just_pressed(input_jump_name)
		var input_sprint = Input.is_action_pressed(input_sprint_name)
		print(input_axis.y)
		
		# Lean head when moving left/right
		head.lean(input_axis.y, delta)
		
		if input_sprint and input_axis > Vector2.ZERO:
			stamina = clamp(stamina - (depletion_rate * delta), 0 , 100)
		else:
			stamina = clamp(stamina + (recovery_rate * delta), 0 , 100)
		
		if stamina > 0:
			can_sprint = true
		else: 
			can_sprint = false
			
		move(delta, input_axis, input_jump, input_sprint)
	else:
		move(delta)
	
	
	move_and_slide()

	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_head(event.relative)

func rotate_head(mouse_axis : Vector2) -> void:
	head.rotate_camera(mouse_axis)


func move(_delta: float, input_axis := Vector2.ZERO, input_jump := false, input_sprint := false):
	var _direction_base_node = self
	var direction = _direction_input(input_axis, _direction_base_node)
	
	var multiplier: float
	
	if is_on_floor():
		if input_jump and not head_check.is_colliding():
			velocity.y = jump_height
	else:
		velocity.y -= gravity * _delta
		
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor:
		temp_accel *= air_control
	
	if input_sprint and can_sprint:
		multiplier = sprint_speed_multiplier
	else:
		multiplier = 1.0
	
	temp_vel = temp_vel.lerp(target * multiplier, temp_accel * _delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	

func _direction_input(input : Vector2, aim_node : Node3D) -> Vector3:
	_direction = Vector3()
	var aim = aim_node.get_global_transform().basis
	if input.x >= 0.5:
		_direction -= aim.z
	if input.x <= -0.5:
		_direction += aim.z
	if input.y <= -0.5:
		_direction -= aim.x
	if input.y >= 0.5:
		_direction += aim.x
	else:
		_direction.y = 0	
	return _direction.normalized()

func die() -> void:
	position = Checkpoints.checkpoint

func _on_hurtbox_body_entered(body: Node3D) -> void:
	die()


func _on_hurtbox_area_entered(area: Area3D) -> void:
	die()
