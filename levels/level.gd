extends Node2D

class_name Level
## Base class for all levels that the player is included in.

@export var starting_position: StartingPosition ## The starting location of the player. This is the players feet location.

var player: Player ## The player.
var player_died := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var totals := {
		"Pig": 0,
		"Chicken": 0,
		"Trophy": 0
	}
	
	for identifier in totals:
		for child in get_children():
			if "identifier" in child:
				if child.identifier == identifier:
					totals[identifier] += 1
	
	if not player:
		player = preload("res://entities/player/player.tscn").instantiate()
	player.global_position = starting_position.global_position
	add_child(player)
	player.get_node("CanvasLayer/HUD").update_stat_totals(totals)

func _exit_tree() -> void:
	if not player_died:
		PlayerStats.on_level_exit()
