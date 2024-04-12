extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not owner.visible or not PlayerStats.speedrun_timer_enabled:
		return

	show()
	PlayerStats.speedrun_timer += delta

	var minutes = PlayerStats.speedrun_timer / 60
	var seconds = fmod(PlayerStats.speedrun_timer, 60)
	var milliseconds = fmod(PlayerStats.speedrun_timer, 1) * 100
	var timer_string = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

	text = timer_string
