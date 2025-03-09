extends CharacterBody2D

var target: CharacterBody2D
var target_acquired = false

var damage = 1
var attack_cooldown = 5
var attack_timer: float = 0.0


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
		target.damage(damage)
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
	queue_free()
