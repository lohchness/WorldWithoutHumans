extends CharacterBody2D

var speed = 400
var accel = 20

var battery: float = 100.0
var health: float = 100.0

var direction : Vector2

var a1_attack: bool = false
@onready var beam_weapon = $BeamWeapon

signal gameover

@onready var weapon_sc: StateChart = $WeaponStateChart

@onready var marker = $Marker

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_laser"):
		weapon_sc.send_event("on_a1_attack")
		

func damage(amount: float) -> void:
	health -= amount
	print("Took " + str(amount) + " damage. Health remaining: " + str(health))
	
	if health <= 0:
		gameover.emit()

## WEAPON STATES

func _on_a_1_attacking_state_entered() -> void:
	# Enable beam functionality
	a1_attack = true
	beam_weapon.visible = true
	

func _on_a_1_attacking_state_exited() -> void:
	# Disable beam functionality
	a1_attack = false
	beam_weapon.visible = false

func _on_a_1_attacking_state_physics_processing(delta: float) -> void:
	var areas = $Marker/Area2D.get_overlapping_areas()
	for i in areas:
		i.destroy()
