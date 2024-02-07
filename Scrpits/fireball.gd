extends Area3D

@export var speed : = 10.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.speed_scale = speed / 10.0

func _on_body_entered(body: Node3D) -> void:
	call_deferred('queue_free')

func _physics_process(delta: float) -> void:
	position += Vector3.FORWARD * speed * delta
