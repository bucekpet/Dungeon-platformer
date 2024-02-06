extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var aflame: bool = false

func _ready() -> void:
	if aflame:
		animation_player.play('Active')


func _on_interacted(body: Variant) -> void:
	animation_player.play('Active')
	Checkpoints.update_checkpoint(global_position)
