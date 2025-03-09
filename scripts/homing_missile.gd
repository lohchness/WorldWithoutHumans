extends CharacterBody2D

var speed: float = randi_range(150, 250)
var orig_speed
var max_speed = 300

var rotation_speed: float = 2.0


var max_lifetime: float = 6.5
var explosion_scene: PackedScene = preload("res://scenes/ExplosionSmall.tscn")
var damage: float = 3.0
var seeking_enabled: bool = true
var seeking_delay: float = randf_range(0.3, 1.0)

var target: Node2D = null
var lifetime: float = 0.0
var seeking_timer: float = 0.0

var immune_timer = 1.0 # Time immune to itself

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	target = get_tree().get_first_node_in_group("Player")
	# Start with a slight delay before seeking
	seeking_timer = seeking_delay
	
	rotation = randf_range(0, 2*PI)
	orig_speed = speed

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
	
	# Faster rotation speed the closer it is to the player
	if global_position.distance_to(target.global_position) < 150:
		rotation_speed = 4
		speed = max_speed
	else:
		rotation_speed = 2
		speed = orig_speed
	
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
	## TODO: Sometimes missiles that collide with each other all dont explode
	
	immune_timer -= delta
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.has_method("damage"):
			collider.damage(damage)
			explode()
			return
		
		# Explode itself 
		if immune_timer < 0:
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
