extends Label
@onready var player_state_machine: PlayerStateMachine = $"../PlayerStateMachine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "State: " + player_state_machine.current_state.name
