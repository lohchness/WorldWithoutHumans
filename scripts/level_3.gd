extends Node2D

var infantry_spawners: Array
@onready var infantry = preload("res://scenes/infantry.tscn")
@onready var boss_hp_bar: BossHPBar = $"Boss HP Bar"

func _ready() -> void:
	infantry_spawners = $"Infantry Spawners".get_children()
	$Boss.connect("health_changed", $"Boss HP Bar".update_boss_health)


func _on_infarty_timer_timeout() -> void:
	for i in range(2):
		var s = infantry.instantiate()
		s.global_transform = infantry_spawners.pick_random().global_transform
		get_tree().root.add_child(s)
