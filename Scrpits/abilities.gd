extends Node

var sprint_ability := false
var jump_ability := false

var abilities := {"sprint":sprint_ability, "jump":jump_ability}

func activate_ability(name: String) -> void:
	abilities[name] = true
