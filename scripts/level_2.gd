extends Node2D

var player_trigger = false

var jet_spawners: Array
@onready var jet = preload("res://scenes/fighter_jets.tscn")
@onready var pause_menu: Control = $Player/Camera2D2/PauseMenu

var buildings_destroyed = 0
var artillery_destroyed = 0
@onready var objective_1: Label = $Player/Camera2D2/Objective1
@onready var objective_2: Label = $Player/Camera2D2/Objective2

func _ready() -> void:
	jet_spawners = $FighterJetSpawner.get_children()
	
	pause_menu.hide()
	pause_menu.get_child(2).get_child(0).connect("pressed", unpause)
	pause_menu.get_child(2).get_child(1).connect("pressed", quit)
	
	var b = $Buildings.get_children()
	for i in b:
		i.connect("destroyed", add_building_destroyed)
	
	var a = $Artillery.get_children()
	for i in a:
		i.connect("artydestroyed", add_artillery_destroyed)

func _on_jetfighter_trigger_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if not player_trigger:
			player_trigger = true
			$"Jetfighter Timer".start()

func _physics_process(delta: float) -> void:
	if buildings_destroyed >= 120 and artillery_destroyed >= 13:
		modulate -= Color(0,0,0, 1 * delta)
		if modulate.a <= 0:
			get_tree().change_scene_to_file("res://scenes/level_2_complete.tscn")

func _on_jetfighter_timer_timeout() -> void:
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
	objective_1.text = "Destroy " + str(buildings_destroyed) + "/120 Buildings!"

func add_artillery_destroyed():
	artillery_destroyed += 1
	objective_2.text = "Destroy " + str(artillery_destroyed) + "/13 Artillery!"
