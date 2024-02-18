extends CharacterBody2D

class_name Enemy

## Enemy Class
##
## This is the base class for all enemies

@export_category("Movement")
@export var speed: int ## Movement speed for the enemy.
@export var sprint_modifier: float = 1 ## Movement speed modifier when aggressive towards the player.

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") ## Gravity.
var facing_right := false: ## Is the sprite facing to the right or not.
	set(new_value):
		facing_right = new_value
		scale.x = -1

@export_category("Combat")
@export var damage: int ## Damage dealt when contacting the player.
@export_range(1, 100, 1, "or_greater") var max_health: int = 1 ## Maximum health for this enemy.

var health: int ## Current health for this enemy.
var player: Player ## Player.

@onready var health_bar: EnemyHealthBar = $EnemyHealthBar ## Health bar that shows up after taking damage.

@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var hit_state: Node = $EnemyStateMachine/Hit
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var state_debug_label: Label = $StateDebugLabel


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
	var warnings: Array[String] = []
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
	await enemy_state_machine.state_process_finished
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Flip the enemy if it's trying to move based on its
	if velocity.x > 0 and not facing_right:
		facing_right = true
	if velocity.x < 0 and facing_right:
		facing_right = false

	animation_tree.set("parameters/Wander/blend_position", velocity.x)

	move_and_slide()


func take_damage(_damage: int) -> void: ## This is called whenever a player hitbox enters this enemy's hurtbox.
	$DamageSound.play()
	if not _damage:
		return

	if health > 0:
		health -= _damage
		enemy_state_machine.current_state.next_state = hit_state

	health_bar.update_health(max_health, health)

	if health < 0:
		health = 0
	if health == 0:
		die()


func die() -> void: ## This is called whenever this enemy dies.
	queue_free()
