extends Node2D

var infantry_spawners: Array
@onready var infantry = preload("res://scenes/infantry.tscn")

func _ready() -> void:
	infantry_spawners = $"Infantry Spawners".get_children()

func _on_jetfighter_timer_timeout() -> void:
	for i in range(2):
		var s = infantry.instantiate()
		s.global_transform = infantry_spawners.pick_random().global_transform
		get_tree().root.add_child(s)
