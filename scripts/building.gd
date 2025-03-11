extends Node2D
class_name Building

var explosion_scene: PackedScene = preload("res://scenes/ExplosionMedium.tscn")

@onready var sprite = $Sprite2D

@export var allsprites: Array[Texture] = []

func _ready() -> void:
	sprite.texture = allsprites.pick_random()
	

func destroy() -> void:
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().root.get_child(0).add_child(explosion)
	queue_free()
