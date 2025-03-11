extends AnimatedSprite2D

@export var players: Array[AudioStreamPlayer2D] = []
@onready var chosen_player: AudioStreamPlayer2D = null


func _ready() -> void:
	var num_anims = sprite_frames.get_animation_names().size()
	var rand = randi_range(0, num_anims-1)
	animation = sprite_frames.get_animation_names()[rand]
	play()
	
	if len(players) > 0:
		chosen_player = players.pick_random()
		chosen_player.connect("finished", _on_animation_finished)
		chosen_player.play()

func _on_animation_finished() -> void:
	if chosen_player:
		visible = false
	else:
		queue_free()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
