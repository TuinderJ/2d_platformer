extends Trap
class_name SpikeTrap

@onready var texture_rect: TextureRect = $TextureRect
@onready var collision_shape_2d: CollisionShape2D = $TextureRect/HitBox/CollisionShape2D

var pixels := 8

@export_range(2, 100) var number_of_spikes := 2

func _ready() -> void:
	texture_rect.size.x = number_of_spikes * pixels
	var rectangle_shape_2d: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape_2d.size.x = number_of_spikes * pixels
	rectangle_shape_2d.size.y = 8

	collision_shape_2d.position.x = (number_of_spikes * pixels / 2) - (pixels)
	collision_shape_2d.position.y = 4
	collision_shape_2d.shape = rectangle_shape_2d
