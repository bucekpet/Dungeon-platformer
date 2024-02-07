extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_lever_interacted(body: Variant) -> void:
	animation_player.play('Open')
