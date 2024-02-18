@tool
extends CharacterBody2D

class_name Enemy

## Emnemy Class
##
## This is the base class for all enemies

@export_category("Movement")
@export var speed: int ## Movement speed for the enemy.

@export_category("Combat")
@export var damage: int ## Damage dealt when contacting the player.
@export_range(1, 100, 1, "or_greater") var max_health: int = 1 ## Maximum health for this enemy.

var health: int ## Current health for this enemy.
@onready var health_bar: EnemyHealthBar = $EnemyHealthBar ## Health bar that shows up after taking damage.


func _get_configuration_warnings() -> PackedStringArray:
	var has_hit_box: bool = false
	var has_hurt_box: bool = false
	var has_health_bar: bool = false
	var has_sprite: bool = false
	var has_animation_player: bool = false
	for child in get_children():
		if child is Sprite2D:
			has_sprite = true
			for sprite_child in child.get_children():
				if sprite_child is HitBox:
					has_hit_box = true
				if sprite_child is HurtBox:
					has_hurt_box = true
		if child is EnemyHealthBar:
			has_health_bar = true
		if child is AnimationPlayer:
			has_animation_player = true
	var warnings: Array
	if not has_sprite:
		warnings.push_back("This enemy needs to have a Sprite2D.")
	if not has_hit_box:
		warnings.push_back("The Sprite2D needs to have a HitBox.")
	if not has_hurt_box:
		warnings.push_back("The Sprite2D needs to have a HurtBox.")
	if not has_animation_player:
		warnings.push_back("This enemy needs to have an AnimationPlayer.")
	if not has_health_bar:
		warnings.push_back("This enemy needs to have an EnemyHealthBar.")
	return warnings


func _ready() -> void:
	health = max_health


func _physics_process(delta: float) -> void:
	if velocity.x > 0:
		scale = Vector2(-1, 0)
	if velocity.x < 0:
		scale = Vector2(1, 0)

	move_and_slide()


func take_damage(_damage: int) -> void: ## This is called whenever a player hitbox enters this enemy's hurtbox.
	if not _damage:
		return

	if health > 0:
		health -= _damage

	health_bar.update_health(max_health, health)

	if health <= 0:
		health = 0
		die()


func die() -> void: ## This is called whenever this enemy dies.
	queue_free()
