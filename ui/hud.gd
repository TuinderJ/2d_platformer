extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var empty_hearts_container: HBoxContainer = $MarginContainer/PanelContainer/EmptyHeartsContainer
@onready var full_hearts_container: HBoxContainer = $MarginContainer/PanelContainer/FullHeartsContainer
@onready var stats_container: HBoxContainer = $MarginContainer2/StatsContainer

func _ready():
	PlayerStats.stats_updated.connect(_player_stats_updated)

func update_max_health(max_health: int) -> void:
	margin_container.size = Vector2(16 * max_health + 8, 24) # 16 pixel base + 4 pixel margin on each side.
	add_empty_hearts(max_health)
	if hidden:
		show()

func update_health(health: int) -> void:
	if health > empty_hearts_container.get_child_count():
		return
	if health < 0:
		return

	if health < full_hearts_container.get_child_count():
		var difference = full_hearts_container.get_child_count() - health
		for i in difference:
			full_hearts_container.get_children()[0].free()

	if health > full_hearts_container.get_child_count():
		var difference = health - full_hearts_container.get_child_count()
		add_full_hearts(difference)

func add_empty_hearts(count: int) -> void:
	for i in count:
		var empty_heart_texture_rect := TextureRect.new()
		empty_heart_texture_rect.texture = load("res://assets/Menu/UI/Health Heart Empty.png")
		empty_hearts_container.add_child(empty_heart_texture_rect)

func add_full_hearts(count: int) -> void:
	for i in count:
		var full_heart_texture_rect := TextureRect.new()
		full_heart_texture_rect.texture = load("res://assets/Menu/UI/Health Heart.png")
		full_heart_texture_rect.flip_h = true
		full_hearts_container.add_child(full_heart_texture_rect)

func _player_stats_updated(stats) -> void:
	for key in stats:
		prints(key, stats[key])
		for child in stats_container.get_children():
			if child.name == key:
				child.text = str(stats[key])
