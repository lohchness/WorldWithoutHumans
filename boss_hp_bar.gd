extends Node2D
class_name BossHPBar

## 100-60: Phase 1
## 60-20: Phase 2
## 20-0: Phase 3

@onready var sprite_2d_2: Sprite2D = $Sprite2D2

func update_boss_health(new_health: float):
	print(new_health)
	sprite_2d_2.set_scale(Vector2(new_health, 1))
