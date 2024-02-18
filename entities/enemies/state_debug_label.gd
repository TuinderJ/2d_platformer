extends Label

class_name EnemyStateDebugLabel

@onready var enemy_state_machine: EnemyStateMachine = $"../EnemyStateMachine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	text = "State: " + enemy_state_machine.current_state.name
