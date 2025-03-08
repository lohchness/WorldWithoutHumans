extends CharacterBody2D

const PHASE_1_SPEED: int = 120
const PHASE_1_ACCEL: int = 10


var speed: float
var accel: float

var target: CharacterBody2D

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	speed = PHASE_1_SPEED
	accel = PHASE_1_ACCEL
