extends Node


const SPAWN_RADIUS: float = 330.0

@export var basic_enemy_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", _on_timer_timeout)


func _on_timer_timeout() -> void:
	var player: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null == player:
		return

	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = (
		player.global_position + (random_direction * SPAWN_RADIUS)
	)

	var basic_enemy: CharacterBody2D = (
		basic_enemy_scene.instantiate() as CharacterBody2D
	)

	get_parent().add_child(basic_enemy)

	basic_enemy.global_position = spawn_position
