extends CharacterBody2D

var speed = 400
var accel = 20

var battery: float = 100.0
var health: float = 100.0

var direction : Vector2

@onready var beam_weapon = $BeamWeapon

signal gameover

@onready var weapon_sc: StateChart = $WeaponStateChart

@onready var marker = $Marker

@onready var laser_cooldown_timer: Timer = $Abilities/Timers/Ability1Cooldown
@onready var magnet_cooldown_timer: Timer = $Abilities/Timers/Ability2Cooldown

@onready var laser_timer_background = $Abilities/Icons/Cooldown/Ability1TimerBackground
@onready var laser_timer_text = $Abilities/Icons/Cooldown/Ability1TimerText

@onready var laser_finish_attack_transition = $"WeaponStateChart/Weapons/A1/A1 Attacking/On Finish Attack"
@onready var laser_cooldown_finish_transition = $"WeaponStateChart/Weapons/A1/A1 Cooldown/On Cooldown Finish"

var laser_on_cooldown = false

func _ready() -> void:
	magnet_area.monitoring = false
	
	laser_cooldown_timer.wait_time = int(laser_finish_attack_transition.delay_in_seconds) + int(laser_cooldown_finish_transition.delay_in_seconds)

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	move_and_slide()
	
	## Update ability hotbar
	if laser_on_cooldown:
		laser_timer_background.visible = true
		laser_timer_text.visible = true
		laser_timer_text.text = str(ceil(laser_cooldown_timer.time_left))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_laser"):
		weapon_sc.send_event("on_a1_attack")
	if event.is_action_pressed("fire_magnet"):
		weapon_sc.send_event("on_a2_attack")
		

func damage(amount: float) -> void:
	health -= amount
	print("Took " + str(amount) + " damage. Health remaining: " + str(health))
	
	if health <= 0:
		gameover.emit()

## WEAPON STATES

func _on_a_1_attacking_state_entered() -> void:
	# Enable beam functionality
	beam_weapon.visible = true
	laser_cooldown_timer.start()
	laser_on_cooldown = true

func _on_a_1_attacking_state_exited() -> void:
	# Disable beam functionality
	beam_weapon.visible = false

func _on_a_1_attacking_state_physics_processing(delta: float) -> void:
	var areas = $Marker/Area2D.get_overlapping_areas()
	for i in areas:
		i.destroy()

@onready var magnet_area = $MagnetWeapon/MagnetArea
@onready var magnet_sprite = $MagnetWeapon/MagnetSprite

func _on_a_2_attacking_state_entered() -> void:
	magnet_area.monitoring = true
	magnet_sprite.visible = true

func _on_a_2_attacking_state_exited() -> void:
	magnet_area.monitoring = false
	magnet_sprite.visible = false

func _on_magnet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Infantry"):
		body.die()

func picked_up_corpse():
	print("hello")

func _on_ability_1_cooldown_timeout() -> void:
	laser_on_cooldown = false
	laser_timer_background.visible = false
	laser_timer_text.visible = false
