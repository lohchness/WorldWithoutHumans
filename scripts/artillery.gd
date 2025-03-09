extends Area2D

var min_rotation: float = -30.0
var max_rotation: float = 30.0

var attack_cooldown: float = 5.0
var attack_time: float = 4.0

var target: CharacterBody2D
var target_in_range = false

var attacks = 0
var maxattacks = 4

var warning: PackedScene = preload("res://scenes/warning.tscn")
var explosion_scene: PackedScene = preload("res://scenes/ExplosionMedium.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")


func _physics_process(delta: float) -> void:
	var direction = target.global_position.x - global_position.x
	
	#$ArtilleryCannon.rotation
	
	attack_time += delta
	if attack_time >= attack_cooldown:
		if target_in_range:
			$FireCooldown.start()
			attack_time = 0

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

func _on_fire_cooldown_timeout() -> void:
	fire_artillery()
	
	attacks += 1
	if attacks == maxattacks:
		$FireCooldown.stop()
		attacks = 0

func destroy():
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().get_root().add_child(explosion)
	queue_free()
