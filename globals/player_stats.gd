extends Node

var stats := {
	"Pig": 0,
	"Chicken": 0,
	"Trophy": 0,
	"Jumps": 0,
	"Deaths": 0
}

var movement := {
	"max_jumps": 1,
	"max_wall_jumps": 0,
	"temp_max_jumps": 0,
	"temp_max_wall_jumps": 0
}

var speedrun_timer := 0.0

var current_level_stats := {
	"Pig": 0,
	"Chicken": 0,
	"Trophy": 0,
}

var speedrun_timer_enabled := true

signal stats_updated(stats, current_level_stats)

func _ready() -> void:
	update_totals()

func update_stats(key, value_to_increase_by) -> void:
	stats[key] += value_to_increase_by
	stats_updated.emit(stats, current_level_stats)

func update_level_stats(key, value_to_increase_by) -> void:
	current_level_stats[key] += value_to_increase_by
	stats_updated.emit(stats, current_level_stats)

func update_totals() -> void:
	var data_file = FileAccess.open("res://globals/totals.json", FileAccess.WRITE)
	var level_files = DirAccess.open("res://levels/").get_files()

	var new_totals := {
		"Pig": 0,
		"Chicken": 0,
		"Trophy": 0
	}

	for level_file in level_files:
		if level_file.ends_with("tscn"):
			var level = load("res://levels/" + level_file).instantiate()
			var pig_total = find_totals(level, "Pig")
			var chicken_total = find_totals(level, "Chicken")
			var trophy_total = find_totals(level, "Trophy")
			new_totals.Pig += pig_total
			new_totals.Chicken += chicken_total
			new_totals.Trophy += trophy_total

	data_file.store_string(JSON.stringify(new_totals))

func find_totals(level, identifier) -> int:
	var total := 0
	for child in level.get_children():
		if "identifier" in child:
			if child.identifier == identifier:
				total += 1
	return total

func read_totals() -> Dictionary:
	var data_file = FileAccess.open("res://globals/totals.json", FileAccess.READ)
	var json_data = JSON.parse_string(data_file.get_as_text())
	return json_data

func on_level_exit() -> void:
	stats.Pig += current_level_stats.Pig
	stats.Chicken += current_level_stats.Chicken
	stats.Trophy += current_level_stats.Trophy
	current_level_stats.Pig = 0
	current_level_stats.Chicken = 0
	current_level_stats.Trophy = 0
	movement.max_jumps += movement.temp_max_jumps
	movement.max_wall_jumps += movement.temp_max_wall_jumps
	movement.temp_max_jumps = 0
	movement.temp_max_wall_jumps = 0
	stats_updated.emit(stats, current_level_stats)

func reset_level_stats() -> void:
	current_level_stats.Pig = 0
	current_level_stats.Chicken = 0
	current_level_stats.Trophy = 0
	stats_updated.emit(stats, current_level_stats)
	movement.temp_max_jumps = 0
	movement.temp_max_wall_jumps = 0
