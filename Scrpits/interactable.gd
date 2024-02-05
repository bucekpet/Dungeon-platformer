class_name Interactable
extends Node3D

signal interacted(body)

@export var one_way: bool = true

var active: bool = true

func interact(body):
	if active:
		emit_signal('interacted', body)
		if one_way:
			active = false

