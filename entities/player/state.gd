extends Node

class_name State

@export var can_move := true

var next_state: State
var playback: AnimationNodeStateMachinePlayback


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass


func state_input(event: InputEvent) -> void:
	pass


func state_process(delta: float) -> void:
	pass
