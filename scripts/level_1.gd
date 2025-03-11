extends Node2D
class_name Level1

var jet_spawners: Array
@onready var jet = preload("res://scenes/fighter_jets.tscn")
@onready var pause_menu: Control = $Player/Camera2D2/PauseMenu

func _ready() -> void:
	jet_spawners = $FighterJetSpawner.get_children()
	
	pause_menu.hide()
	pause_menu.get_child(2).get_child(0).connect("pressed", unpause)
	pause_menu.get_child(2).get_child(1).connect("pressed", quit)
	

func _on_fighter_jet_spawn_timer_timeout() -> void:
	for i in range(2):
		var s = jet.instantiate()
		s.global_transform = jet_spawners.pick_random().global_transform
		get_tree().root.get_child(0).add_child(s)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()

func pause():
	get_tree().paused = true
	pause_menu.show()

func unpause():
	get_tree().paused = false
	pause_menu.hide()

func quit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
