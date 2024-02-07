extends Area3D

@export var speed : = 10.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var _direction := Vector3.ZERO

func _ready() -> void:
	animation_player.speed_scale = speed / 10.0

func _on_body_entered(body: Node3D) -> void:
	animation_player.play('Destroy')
	speed = 0.0

func destroy() -> void:
	call_deferred('queue_free')

func set_direction(direction: Vector3) -> void:
	_direction = direction

func _physics_process(delta: float) -> void:
	position += _direction * speed * delta
