extends Node

var time := 0.0
var activated := false
var time_text: String

func _process(delta):
	if activated:	time += delta
	
	var ms = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = fmod(time, 60 * 60) / 60
	
	time_text = "%02d:%02d:%02d" % [min, sec, ms]

func reset_timer() -> void:
	time = 0.0

func start_timer() -> void:
	activated = true

func stop_timer() -> void:
	activated = false
