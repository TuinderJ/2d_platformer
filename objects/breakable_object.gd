extends StaticBody2D

class_name BreakableObject

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var health := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func take_damage() -> void:
	if health <= 0:
		return
	health -= 1
	if health > 0:
		animation_player.play("hit")
	else:
		animation_player.play("break")
	print(health)
