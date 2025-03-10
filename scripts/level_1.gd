extends Node2D
class_name Level1

var jet_spawners: Array
@onready var jet = preload("res://scenes/fighter_jets.tscn")

func _ready() -> void:
	jet_spawners = $FighterJetSpawner.get_children()
	

func _on_fighter_jet_spawn_timer_timeout() -> void:
	for i in range(2):
		var s = jet.instantiate()
		s.global_transform = jet_spawners.pick_random().global_transform
		get_tree().root.add_child(s)
