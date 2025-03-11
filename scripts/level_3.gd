extends Node2D

var infantry_spawners: Array
@onready var infantry = preload("res://scenes/infantry.tscn")
@onready var boss_hp_bar: BossHPBar = $"Player/Camera2D/Boss HP Bar"
@onready var pause_menu: Control = $Player/Camera2D/PauseMenu

func _ready() -> void:
	infantry_spawners = $"Infantry Spawners".get_children()
	$Boss.connect("health_changed", boss_hp_bar.update_boss_health)
	$Boss.connect("player_detected", move_hp_bar)
	
	origpos = Vector2(boss_hp_bar.position)
	
	pause_menu.hide()
	pause_menu.get_child(2).get_child(0).connect("pressed", unpause)
	pause_menu.get_child(2).get_child(1).connect("pressed", quit)

var origpos: Vector2
var targpos = Vector2(0, -290)
var healthon = false

func _physics_process(delta: float) -> void:
	if healthon:
		boss_hp_bar.position = lerp(boss_hp_bar.position, targpos, 5 * delta)

func move_hp_bar():
	#targpos = origpos + Vector2(0, 63)
	#print("New position: " + str(origpos + targpos))
	print("here")
	healthon = true

func _on_infarty_timer_timeout() -> void:
	for i in range(2):
		var s = infantry.instantiate()
		s.global_transform = infantry_spawners.pick_random().global_transform
		get_tree().root.get_child(0).add_child(s)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()

func pause():
	get_tree().paused = true
	$Player/Camera2D/PauseMenu.show()

func unpause():
	get_tree().paused = false
	$Player/Camera2D/PauseMenu.hide()

func quit():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
