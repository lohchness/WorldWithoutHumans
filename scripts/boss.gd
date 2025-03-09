extends CharacterBody2D

const PHASE_1_SPEED: int = 70
const PHASE_1_ACCEL: int = 10

const PHASE_2_SPEED: int = 100
const PHASE_2_ACCEL: int = 10

var speed: float
var accel: float

var health: float = 100.0

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
	
	p2_laser_windup.visible = false
	p2_laser_actual.visible = false

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

# Boss starts with artillery on cooldown
var p1_attack_cooldown: float = 2.0
var p1_attack_timer: float = 0.0
var big_warning: PackedScene = preload("res://scenes/big_warning.tscn")

func _on_phase_1_state_entered() -> void:
	face_sprite.texture = happy_face

func _on_walk_state_physics_processing(delta: float) -> void:
	var dir = (target.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()
	
	p1_attack_timer += delta
	if p1_attack_timer >= p1_attack_cooldown:
		phases_sc.send_event("on_attack")

## Stationary only serves to "prime" the attack
func _on_stationary_state_physics_processing(delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()

func _on_stationary_state_exited() -> void:
	# Artillery attack after "priming" in Stationary state
	p1_attack_timer = 0
	
	var s: Node2D = big_warning.instantiate()
	s.global_position = target.global_position + target.velocity / 3
	get_tree().root.add_child(s)

func _on_phase_1_state_physics_processing(delta: float) -> void:
	if health <= 50.0:
		phases_sc.send_event("on_phase_1_finish")

## PHASE 2

var p2_dash_attack_timer: float = 0
var p2_current_dashes: int = 0
var p2_num_dashes = 1

var p2_dash_attack_vector: Vector2
var p2_dash_attack_duration = 1
var p2_dash_attack_speed = 400

var modulate_timer = 0
@onready var p2_laser_windup = $LaserBeam/LaserBeamWindup
@onready var p2_laser_actual = $LaserBeam/LaserBeamActual

func _on_phase_2_state_entered() -> void:
	speed = PHASE_2_SPEED
	accel = PHASE_2_ACCEL
	face_sprite.texture = annoyed_face
	$"PhaseStateChart/Phases/Phase 2/P2 Big Arty Fire Cooldown".start()

func _on_brisk_state_physics_processing(delta: float) -> void:
	var dir = (target.global_position - global_position).normalized()
	
	velocity.x = move_toward(velocity.x, speed * dir.x, accel)
	velocity.y = move_toward(velocity.y, speed * dir.y, accel)
	move_and_slide()

func _on_windup_state_entered() -> void:
	velocity = Vector2.ZERO
	
	
	# Send to Attack compound state
	phases_sc.send_event("p2AttackWindup")

func _on_windup_state_physics_processing(delta: float) -> void:
	move_and_slide()

func _on_dash_attack_state_entered() -> void:
	
	p2_dash_attack_timer = 0
	p2_current_dashes += 1
	p2_dash_attack_vector = global_position.direction_to(target.global_position)

func _on_dash_attack_state_physics_processing(delta: float) -> void:
	p2_dash_attack_timer += delta
	if p2_dash_attack_timer >= p2_dash_attack_duration:
		phases_sc.send_event("on_dash_attack_finish")
	else:
		velocity = p2_dash_attack_vector * roll_speed(p2_dash_attack_timer)
		move_and_slide()

func roll_speed(elapsed_time : float) -> float:
	var t : float = elapsed_time / p2_dash_attack_duration
	return p2_dash_attack_speed - (p2_dash_attack_speed - 70) * t * t

func _on_dash_attack_state_exited() -> void:
	if p2_current_dashes >= p2_num_dashes:
		phases_sc.send_event("on_attack_finish")

## P2 Attack

func _on_p_2_attack_windup_state_entered() -> void:
	modulate_timer = 0
	p2_laser_windup.visible = true
	p2_laser_windup.set("modulate", Color(1,1,1,0))

func _on_p_2_attack_windup_state_physics_processing(delta: float) -> void:
	modulate_timer += delta
	## !!! The third parameter is transition to P2AttackActual
	var alpha = remap(modulate_timer, 0, 1.5, 0, 1) 
	p2_laser_windup.set("modulate", Color(1,1,1, alpha))

func _on_p_2_attack_windup_state_exited() -> void:
	p2_laser_windup.visible = false

func _on_p_2_attack_actual_state_entered() -> void:
	modulate_timer = 0
	p2_laser_actual.visible = true

func _on_p_2_attack_actual_state_physics_processing(delta: float) -> void:
	modulate_timer += delta
	## !!! The third parameter is transition to P2AttackIdle
	var alpha = remap(modulate_timer, 0, 1.0, 1, 0)
	p2_laser_actual.set("modulate", Color(1,1,1,alpha))

func _on_p_2_attack_actual_state_exited() -> void:
	p2_laser_actual.visible = false

func _on_p_2_big_arty_fire_cooldown_timeout() -> void:
	$"PhaseStateChart/Phases/Phase 2/P2 Big Arty Fire Separation".start()
	p2_missiles_total = randi_range(1, 3)

var p2_missiles_fired = 0
var p2_missiles_total

func _on_p_2_big_arty_fire_separation_timeout() -> void:
	p2_missiles_fired += 1
	var s: Node2D = big_warning.instantiate()
	s.global_position = target.global_position
	get_tree().root.add_child(s)
	if p2_missiles_fired == p2_missiles_total:
		$"PhaseStateChart/Phases/Phase 2/P2 Big Arty Fire Separation".stop()
		p2_missiles_fired = 0


func _on_phase_2_state_exited() -> void:
	$"PhaseStateChart/Phases/Phase 2/P2 Big Arty Fire Cooldown".stop()
