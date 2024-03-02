extends Node

var time := 0.0
var activated := false
var time_text: String

var best_time := 999999999.0

const SAVEFILE := "user://dd.save"

func _ready() -> void:
	load_best()

func _process(delta):
	if activated:	time += delta
	

func convert_time(time: float) -> String:
	var ms = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = fmod(time, 60 * 60) / 60
	return "%02d:%02d:%02d" % [min, sec, ms]

func reset_timer() -> void:
	time = 0.0

func start_timer() -> void:
	activated = true

func stop_timer() -> void:
	activated = false

func save_best() -> void:
	if time < best_time:
		var file := FileAccess.open(SAVEFILE,FileAccess.WRITE_READ)
		file.store_float(time)
		# Close file
		file = null

func load_best() -> void:
	var file := FileAccess.open(SAVEFILE,FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		best_time = file.get_float()
	# Close file
	file = null
