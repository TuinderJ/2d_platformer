extends Area2D

class_name HitBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 4
	collision_mask = 0
