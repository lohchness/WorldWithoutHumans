extends Area2D

var min_rotation: float = -30.0
var max_rotation: float = 30.0

var attack_cooldown: float = 10.0
var attack_time: float = 0.0

var target: CharacterBody2D
var target_in_range = false
var attacks = 4

var warning: PackedScene = preload("res://scenes/warning.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	var direction = target.global_position.x - global_position.x
	
	#$ArtilleryCannon.rotation
	fire_artillery()
	
	#attack_time += delta
	#if attack_time >= attack_cooldown:
		#if target_in_range:
			#fire_artillery()

func fire_artillery():
	var s: Node2D = warning.instantiate()
	# Spawn Warning ahead of where player is moving
	s.global_position = target.global_position + target.velocity / 2
	get_tree().root.add_child(s)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		target_in_range = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"): 
		target_in_range = false
