extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
