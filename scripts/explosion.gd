extends AnimatedSprite2D

func _ready() -> void:
	var num_anims = sprite_frames.get_animation_names().size()
	var rand = randi_range(0, num_anims-1)
	animation = sprite_frames.get_animation_names()[rand]
	play()

func _on_animation_finished() -> void:
	queue_free()
