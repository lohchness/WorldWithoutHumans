extends Node2D
class_name Level1

var jet_spawners: Array
@onready var jet = preload("res://scenes/fighter_jets.tscn")
@onready var pause_menu: Control = $Player/Camera2D2/PauseMenu

var buildings_destroyed = 0
@onready var objective_1: Label = $Player/Camera2D2/Objective1

func _ready() -> void:
	jet_spawners = $FighterJetSpawner.get_children()
	
	pause_menu.hide()
	pause_menu.get_child(2).get_child(0).connect("pressed", unpause)
	pause_menu.get_child(2).get_child(1).connect("pressed", quit)
	
	#var b = get_tree().get_nodes_in_group("Building")
	var b = $Buildings.get_children()
	for i in b:
		i.connect("destroyed", add_building_destroyed)

func _physics_process(delta: float) -> void:
	if buildings_destroyed >= 150:
		modulate -= Color(0,0,0, 1 * delta)
		if modulate.a <= 0:
			get_tree().change_scene_to_file("res://scenes/Level1Complete.tscn")

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

func add_building_destroyed():
	buildings_destroyed += 1
	objective_1.text = "Destroy " + str(buildings_destroyed) + "/150 Buildings!"
