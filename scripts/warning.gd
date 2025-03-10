extends Node2D

var target: CharacterBody2D
var target_acquired = false

var damage = 4

var explosion_scene: PackedScene = preload("res://scenes/FlakBurst.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")

func _on_explode_timer_timeout() -> void:
	
	if target_acquired:
		target.damage(damage)
	
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().get_root().add_child(explosion)
	
	queue_free()

func _on_explode_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_acquired = true

func _on_explode_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_acquired = false
