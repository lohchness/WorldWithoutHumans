extends CharacterBody2D

var speed = 250
var accel = 25

var battery: float = 100.0
var health: float = 100.0

var direction : Vector2

signal gameover


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	velocity.x = move_toward(velocity.x, speed * direction.x, accel)
	velocity.y = move_toward(velocity.y, speed * direction.y, accel)
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire_laser"):
		var areas = $Marker/Area2D.get_overlapping_areas()
		print(len(areas))
		for i in areas:
			i.destroy()

func damage(amount: float) -> void:
	health -= amount
	print("Took " + str(amount) + " damage. Health remaining: " + str(health))
	
	if health <= 0:
		gameover.emit()
