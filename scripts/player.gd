extends CharacterBody2D

var speed = 400
var accel = 20

var battery: float = 100.0
var health: float = 100.0
var maxhealth = 100

var direction : Vector2

@onready var beam_weapon = $BeamWeapon
@onready var healthbar: HPBar = $Abilities/HPBar

signal gameover

@onready var weapon_sc: StateChart = $WeaponStateChart

@onready var marker = $Marker

@onready var laser_cooldown_timer: Timer = $Abilities/Timers/Ability1Cooldown
@onready var laser_timer_background: Sprite2D = $Abilities/Icons/Cooldown/Ability1TimerBackground
@onready var laser_timer_text: Label = $Abilities/Icons/Cooldown/Ability1TimerText
@onready var laser_finish_attack_transition: Transition = $"WeaponStateChart/Weapons/A1/A1 Attacking/On Finish Attack"
@onready var laser_cooldown_finish_transition: Transition = $"WeaponStateChart/Weapons/A1/A1 Cooldown/On Cooldown Finish"

@onready var magnet_cooldown_timer: Timer = $Abilities/Timers/Ability2Cooldown
@onready var magnet_timer_background: Sprite2D = $Abilities/Icons/Cooldown/Ability2TimerBackground
@onready var magnet_timer_text: Label = $Abilities/Icons/Cooldown/Ability2TimerText
@onready var magnet_finish_attack_transition: Transition = $"WeaponStateChart/Weapons/A2/A2 Attacking/Transition"
@onready var magnet_cooldown_finish_transition: Transition = $"WeaponStateChart/Weapons/A2/A2 Cooldown/Transition"

@onready var missileHotbar = $Abilities/Missiles.get_children()
@onready var sfx_missile_5: AudioStreamPlayer2D = $sfx_missile5
@onready var chomp: AudioStreamPlayer2D = $chomp

var laser_on_cooldown = false
var magnet_on_cooldown = false

var humans_consumed: int = 0

var playerdead = false

func _ready() -> void:
	magnet_area.monitoring = false
	
	laser_cooldown_timer.wait_time = int(laser_finish_attack_transition.delay_in_seconds) + int(laser_cooldown_finish_transition.delay_in_seconds)
	magnet_cooldown_timer.wait_time = int(magnet_finish_attack_transition.delay_in_seconds) + int(magnet_cooldown_finish_transition.delay_in_seconds)

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
	if magnet_on_cooldown:
		magnet_timer_background.visible = true
		magnet_timer_text.visible = true
		magnet_timer_text.text = str(ceil(magnet_cooldown_timer.time_left))
	
	for i in range(max_missiles):
		if i <= current_missiles - 1:
			missileHotbar[i].visible = true
		else:
			missileHotbar[i].visible = false
	
	if playerdead:
		var a = get_tree().root.get_child(0)
		a.modulate -= Color(0,0,0, 1 * delta)
		if a.modulate.a <= 0:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_laser"):
		if not laser_on_cooldown:
			$laser.play()
		weapon_sc.send_event("on_a1_attack")
	if event.is_action_pressed("fire_magnet"):
		weapon_sc.send_event("on_a2_attack")
	if event.is_action_pressed("fire_missiles"):
		fire_missiles()
		sfx_missile_5.play()
	if event.is_action_pressed("use_healing"):
		if humans_consumed > 0:
			chomp.play()
		convert_humans()

func damage(amount: float) -> void:
	
	if health/maxhealth >= .10:
		health -= amount/1.5
	else:
		health -= amount
	
	if health <= 0:
		health = 0
		playerdead = true
	
	healthbar.update_healthpercent(health / maxhealth)
	
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
	
	var bodies = $Marker/Area2D2.get_overlapping_bodies()
	for i in bodies:
		if i.is_in_group("Boss"):
			i.damage(13*delta)
	

@onready var magnet_area = $MagnetWeapon/MagnetArea
@onready var magnet_sprite = $MagnetWeapon/MagnetSprite

func _on_a_2_attacking_state_entered() -> void:
	magnet_area.monitoring = true
	magnet_sprite.visible = true
	magnet_cooldown_timer.start()
	magnet_on_cooldown = true

func _on_a_2_attacking_state_exited() -> void:
	magnet_area.monitoring = false
	magnet_sprite.visible = false


func _on_ability_1_cooldown_timeout() -> void:
	laser_on_cooldown = false
	laser_timer_background.visible = false
	laser_timer_text.visible = false


func _on_ability_2_cooldown_timeout() -> void:
	magnet_on_cooldown = false
	magnet_timer_background.visible = false
	magnet_timer_text.visible = false


### Seeking missiles

@onready var seekers: PackedScene = preload("res://scenes/seeking_missile.tscn")
var max_missiles = 8
var current_missiles = 0

func fire_missiles():
	for i in range(current_missiles):
		var s = seekers.instantiate()
		s.global_position = global_position
		get_tree().root.get_child(0).add_child(s)
		current_missiles = 0
	
func _on_missile_countdown_timeout() -> void:
	if current_missiles >= max_missiles:
		return
	current_missiles += 1

## Convert humans to health


func _on_magnet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Infantry"):
		body.die()

func picked_up_corpse():
	if health + humans_consumed > 100:
		return
	humans_consumed += 1
	healthbar.update_humanpercent(humans_consumed / 100.0)

func convert_humans():
	print(str(humans_consumed) + "humans consumed")
	health += humans_consumed
	humans_consumed = 0
	healthbar.update_healthpercent(health / maxhealth)
	healthbar.update_humanpercent(humans_consumed / 100.0) 
