extends Node3D

@export var delay: float = 0
@export var up_time: float = 1
@export var down_time: float = 3
@export var speed_scale: float = 1
@export var always_up: bool = false

@onready var delay_timer: Timer = $Delay
@onready var up_timer: Timer = $"Up-time"
@onready var down_timer: Timer = $"Down-time"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if always_up:
		animation_player.play('Up')
	else:
		animation_player.speed_scale = speed_scale
		up_timer.wait_time = up_time
		down_timer.wait_time = down_time
		
		if delay > 0:
			delay_timer.wait_time = delay
			delay_timer.start()
		else:
			go_up()
			up_timer.start()

func go_up() -> void:
	animation_player.play('Up')
func go_down() -> void:
	animation_player.play('Down')


func _on_delay_timeout() -> void:
	go_up()
	up_timer.start()


func _on_uptime_timeout() -> void:
	go_down()
	down_timer.start()


func _on_downtime_timeout() -> void:
	go_up()
	up_timer.start()
