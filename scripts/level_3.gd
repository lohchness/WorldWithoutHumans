extends Node2D

var infantry_spawners: Array
@onready var infantry = preload("res://scenes/infantry.tscn")
@onready var boss_hp_bar: BossHPBar = $"Player/Camera2D/Boss HP Bar"

func _ready() -> void:
	infantry_spawners = $"Infantry Spawners".get_children()
	$Boss.connect("health_changed", boss_hp_bar.update_boss_health)
	$Boss.connect("player_detected", move_hp_bar)
	
	origpos = Vector2(boss_hp_bar.position)

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
		get_tree().root.add_child(s)
