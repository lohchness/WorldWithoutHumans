extends Sprite2D

@export var corpsesprites: Array[Texture] = []
var target: CharacterBody2D

var time_since_magnet: float = 0

var speedmult: float = 0

func _ready() -> void:
	texture = corpsesprites.pick_random()
	target = get_tree().get_first_node_in_group("Player")
	
	speedmult = randf_range(1, 3)

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(target.global_position, speedmult * delta * (1 + time_since_magnet))
	time_since_magnet += delta
	
	rotate(delta * 10)
