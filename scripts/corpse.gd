extends Sprite2D

@export var corpsesprites: Array[Texture] = []
var target: CharacterBody2D

var time_since_magnet: float = 0

var speedmult: float = 0

signal hit_player

func _ready() -> void:
	texture = corpsesprites.pick_random()
	target = get_tree().get_first_node_in_group("Player")
	
	speedmult = randf_range(1, 3)
	connect("hit_player", Callable(target, "picked_up_corpse"))

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(target.global_position, speedmult * delta * (1 + time_since_magnet))
	time_since_magnet += delta
	
	rotate(delta * 10)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hit_player.emit()
		queue_free()
