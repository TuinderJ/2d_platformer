extends Control

@onready var pig_value = $Panel/Panel/MarginContainer/VBoxContainer/Pigs/Value
@onready var pig_total_value = $Panel/Panel/MarginContainer/VBoxContainer/Pigs/Value2
@onready var chicken_value = $Panel/Panel/MarginContainer/VBoxContainer/Chickens/Value
@onready var chicken_total_value = $Panel/Panel/MarginContainer/VBoxContainer/Chickens/Value2
@onready var trophy_value = $Panel/Panel/MarginContainer/VBoxContainer/Trophies/Value
@onready var trophy_total_value = $Panel/Panel/MarginContainer/VBoxContainer/Trophies/Value2
@onready var jumps_value = $Panel/Panel/MarginContainer/VBoxContainer/Jumps/Value
@onready var deaths_value = $Panel/Panel/MarginContainer/VBoxContainer/Deaths/Value

# Called when the node enters the scene tree for the first time.
func _ready():
	Pause.game_unpaused.connect(close_menu)
	PlayerStats.stats_updated.connect(update_values)
	var totals = PlayerStats.read_totals()
	update_totals(totals)
	update_values(PlayerStats.stats, PlayerStats.current_level_stats)

func close_menu() -> void:
	hide()

func update_totals(totals) -> void:
	pig_total_value.text = "/ " + str(totals.Pig)
	chicken_total_value.text = "/ " + str(totals.Chicken)
	trophy_total_value.text = "/ " + str(totals.Trophy)

func update_values(stats, current_level_stats) -> void:
	pig_value.text = str(stats.Pig + current_level_stats.Pig)
	chicken_value.text = str(stats.Chicken + current_level_stats.Chicken)
	trophy_value.text = str(stats.Trophy + current_level_stats.Trophy)
	jumps_value.text = str(stats.Jumps)
	deaths_value.text = str(stats.Deaths)
