extends Interactable

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_interacted(body: Variant) -> void:
	animation_player.play('Active')

