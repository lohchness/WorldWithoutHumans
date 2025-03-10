extends Node2D
class_name HPBar

var percentage: float = 1.0
var target_percentage

@onready var redbar: Sprite2D = $Red
@onready var humanbar: Sprite2D = $Red/HumanBar

func _ready() -> void:
	target_percentage = percentage

func _physics_process(delta: float) -> void:
	target_percentage = lerp(target_percentage, percentage, 25 * delta)
	redbar.set_scale(Vector2(target_percentage, 1))
	

func update_healthpercent(healthpercent: float):
	target_percentage = healthpercent

func update_humanpercent(humanpercent: float):
	humanbar.set_scale(Vector2(humanpercent, 1))
