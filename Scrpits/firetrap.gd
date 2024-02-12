extends Node3D

@export_group('Spawns activation')
@export var spawn_1_active := true
@export var spawn_2_active := true
@export var spawn_3_active := true
@export var spawn_4_active := true
@export_group('Spawn')
@export var delay := 0.0
@export var spawn_time := 2.0

@onready var target: Marker3D = $Target
@onready var spawn_4: Marker3D = $"Circle/Spawn 1"
@onready var spawn_3: Marker3D = $"Circle_001/Spawn 2"
@onready var spawn_2: Marker3D = $"Circle_002/Spawn 3"
@onready var spawn_1: Marker3D = $"Circle_003/Spawn 4"
@onready var spawns = {spawn_1 : spawn_1_active, spawn_2 : spawn_2_active, spawn_3 : spawn_3_active, spawn_4 : spawn_4_active}
@onready var spawn_timer: Timer = $"Spawn timer"
@onready var delay_timer: Timer = $"Delay timer"

const fireball_preload = preload("res://Objects/fireball.tscn")

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	
	if delay > 0:
		delay_timer.wait_time = delay
		delay_timer.start()
	else:
		spawn_all_fireballs()
		spawn_timer.start()

func spawn_fireball(pos: Vector3, dir: Vector3) -> void:
	var fireball := fireball_preload.instantiate()
	fireball.position = pos
	fireball.set_direction(dir)
	get_tree().get_current_scene().add_child.call_deferred(fireball)

func spawn_all_fireballs() -> void:
	for spawn in spawns:
		if spawns[spawn] == true:
			var direction := global_position.direction_to(target.global_position).normalized()
			spawn_fireball(spawn.global_position + direction * 0.2, direction)
	

func _on_spawn_timer_timeout() -> void:
	spawn_all_fireballs()

func _on_delay_timeout() -> void:
	spawn_all_fireballs()
	spawn_timer.start()
