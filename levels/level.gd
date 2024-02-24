extends Node2D

class_name Level
## Base class for all levels that the player is included in.

@export var starting_position: StartingPosition ## The starting location of the player. This is the players feet location.

var player: Player ## The player.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not player:
		player = preload("res://entities/player/player.tscn").instantiate()
	player.global_position = starting_position.global_position
	add_child(player)
