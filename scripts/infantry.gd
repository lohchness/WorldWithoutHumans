extends CharacterBody2D

var target: CharacterBody2D
var target_acquired = false

var dmg = 1
var attack_cooldown = 5
var attack_timer: float = 0.0

var corpse_scene: PackedScene = preload("res://scenes/corpse.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	$Gunfire.visible = false
	$Timer.wait_time = randf_range(2, 5)

func _physics_process(delta: float) -> void:
	var dir = global_position.direction_to(target.marker.global_position)
	
	velocity = dir * 25
	move_and_slide()


func _on_timer_timeout() -> void:
	if target_acquired:
		$Gunfire.visible = true
		$Gunfirevisible.start()
		target.damage(dmg)
	$Timer.wait_time = randf_range(2, 5)

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_acquired = true

func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_acquired = false

func _on_gunfirevisible_timeout() -> void:
	$Gunfire.visible = false

func die():
	
	for i in randi_range(2, 8):
		var s = corpse_scene.instantiate()
		s.global_position = global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))
		get_tree().root.add_child(s)
	
	queue_free()

func damage(dmg):
	queue_free()
