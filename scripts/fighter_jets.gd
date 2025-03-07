extends CharacterBody2D
class_name FighterJet

## Flies in straight line towards player.
## Fires homing  missiles when player in a certain radius.

var target: CharacterBody2D
var direction: Vector2
var speed: float = 500

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	direction = position.direction_to(target.global_position)
	
	look_at(target.global_position)
	rotate(PI/2) # look_at uses +x direction

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
