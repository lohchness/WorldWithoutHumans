extends CharacterBody2D

@export var speed: float = randi_range(150, 250)
@export var rotation_speed: float = 2.0
@export var max_lifetime: float = 50.0
@export var explosion_scene: PackedScene
@export var damage: float = 3.0
@export var seeking_enabled: bool = true
@export var seeking_delay: float = randf_range(0.3, 1.0)

var target: Node2D = null
var lifetime: float = 0.0
var seeking_timer: float = 0.0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	# Start with a slight delay before seeking
	seeking_timer = seeking_delay
	rotation = randf_range(0, 2*PI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Update lifetime
	lifetime += delta
	if lifetime >= max_lifetime:
		explode()
		return
	
	# Update seeking timer
	if seeking_timer > 0:
		seeking_timer -= delta
	
	# Move forward
	var direction = Vector2.RIGHT.rotated(rotation)
	velocity = direction * speed
	
	# Seek target if available and seeking is enabled
	if target != null and is_instance_valid(target) and seeking_enabled and seeking_timer <= 0:
		var direction_to_target = global_position.direction_to(target.global_position)
		var target_rotation = direction_to_target.angle()
		
		# Rotate towards target with smooth turning
		rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	
	# Move the missile
	move_and_slide()
	
	# Check for collisions
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.has_method("damage"):
			collider.damage(damage)
		
		explode()
		return

# Set the missile's target
func set_target(new_target: Node2D) -> void:
	target = new_target

# Create explosion and remove missile
func explode() -> void:
	# Spawn explosion if provided
	if explosion_scene != null:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().get_root().add_child(explosion)
	
	# Remove this missile
	queue_free()
