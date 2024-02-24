extends State

class_name EnemyHitState

@onready var aggressive_state: Node = $"../Aggressive"


func on_enter() -> void:
	playback.travel("hit")


func on_take_damage_animation_end() -> void:
	next_state = aggressive_state
