extends Area2D


func _on_body_entered(body: Node2D) -> void:
	#BUG: This runs twice for some reason
	print(body, body.has_method("die"))
	if body.has_method("die"):
		body.die()
