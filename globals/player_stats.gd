extends Node

var stats := {
	"Pig": 0,
	"Chicken": 0,
	"Trophy": 0
}

var speedrun_timer_enabled := true

signal stats_updated(stats)

func update_stats(key, value_to_increase_by) -> void:
	stats[key] += value_to_increase_by
	stats_updated.emit(stats)
