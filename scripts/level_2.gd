extends Node2D

var player_trigger = false

var jet_spawners: Array
@onready var jet = preload("res://scenes/fighter_jets.tscn")

func _ready() -> void:
	jet_spawners = $FighterJetSpawner.get_children()

func _on_jetfighter_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not player_trigger:
			player_trigger = true
			$"Jetfighter Timer".start()


func _on_jetfighter_timer_timeout() -> void:
	for i in range(2):
		var s = jet.instantiate()
		s.global_transform = jet_spawners.pick_random().global_transform
		get_tree().root.get_child(0).add_child(s)
