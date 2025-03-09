extends Node2D
class_name Building

var explosion_scene: PackedScene = preload("res://scenes/ExplosionMedium.tscn")

func destroy() -> void:
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().get_root().add_child(explosion)
	queue_free()
