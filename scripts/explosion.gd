extends AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	var num_anims = sprite_frames.get_animation_names().size()
	var rand = randi_range(0, num_anims-1)
	animation = sprite_frames.get_animation_names()[rand]
	play()
	
	if audio_stream_player_2d:
		audio_stream_player_2d.play()

func _on_animation_finished() -> void:
	if audio_stream_player_2d:
		visible = false
	else:
		queue_free()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
