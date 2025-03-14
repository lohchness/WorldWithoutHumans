extends Node2D
class_name HPBar

var percentage: float = 1.0
var target_percentage

@onready var redbar: Sprite2D = $Red
@onready var humanbar: Sprite2D = $HumanBar
@onready var rednode = $Red/Node2D

func _ready() -> void:
	target_percentage = percentage

func _physics_process(delta: float) -> void:
	target_percentage = lerp(target_percentage, percentage, 25 * delta)
	redbar.set_scale(Vector2(target_percentage, 1))
	humanbar.global_position = rednode.global_position

func update_healthpercent(healthpercent: float):
	if healthpercent < 0:
		percentage = 0
		return
	percentage = healthpercent

func update_humanpercent(humanpercent: float):
	humanbar.set_scale(Vector2(humanpercent, 1))
	print(humanpercent)
