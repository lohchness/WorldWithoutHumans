extends CharacterBody2D
class_name FighterJet

## Flies in straight line towards player.
## Fires homing  missiles when player in a certain radius.

var target: CharacterBody2D
var direction: Vector2
var speed: float = 400

var has_fired = false
var num_fired = 0
var missiles = randi_range(3, 6)
var missile_scene: PackedScene = preload("res://scenes/homing_missile.tscn")

var explosion_scene: PackedScene = preload("res://scenes/FlakBurst.tscn")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	direction = position.direction_to(target.global_position)
	
	look_at(target.global_position)
	rotate(PI/2) # look_at uses +x direction

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	if move_and_slide():
		target.damage(5)
		
		var s = explosion_scene.instantiate()
		s.global_position = global_position
		get_tree().root.add_child(s)
		
		queue_free()


func start_firing():
	has_fired = true
	$FireCooldown.start()

func _on_missile_targeting_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		start_firing()

func _on_fire_cooldown_timeout() -> void:
	if num_fired == missiles:
		$FireCooldown.stop()
		return
	
	var s = missile_scene.instantiate()
	s.global_position = global_position
	get_tree().root.add_child(s)
	
	num_fired += 1
