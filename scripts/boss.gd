extends CharacterBody2D

const PHASE_1_SPEED: int = 120
const PHASE_1_ACCEL: int = 10

var speed: float
var accel: float

@onready var phases_sc: StateChart = $PhaseStateChart

var target: CharacterBody2D
var target_acquired = false

@onready var face_sprite: Sprite2D = $"Body Sprites/Face"
@onready var surprised_face = preload("res://sprites/Boss/Surprised.png")
@onready var happy_face = preload("res://sprites/Boss/Happy.png")
@onready var annoyed_face = preload("res://sprites/Boss/Annoyed.png")
@onready var angry = preload("res://sprites/Boss/Angry.png")

func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	speed = PHASE_1_SPEED
	accel = PHASE_1_ACCEL

## PHASE 0

func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target_acquired = true

func _on_chilling_state_physics_processing(delta: float) -> void:
	if target_acquired:
		phases_sc.send_event("on_detect_player")

func _on_player_detected_state_entered() -> void:
	face_sprite.texture = surprised_face

## PHASE 1

func _on_phase_1_state_entered() -> void:
	face_sprite.texture = happy_face


func _on_walk_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.
