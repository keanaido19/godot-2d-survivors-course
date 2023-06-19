extends Node


const MAX_RANGE: float = 150.0


@export var sword_ability: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", _on_timer_timeout)


func _on_timer_timeout() -> void:
	var player: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null == player:
		return

	var enemies: Array[Node] = (
		get_tree().get_nodes_in_group("enemy")
	)

	if 0 == enemies.size():
		return

	enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(
			player.global_position
		) < pow(MAX_RANGE, 2.0)
	)

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		return (
			a.global_position.distance_squared_to(player.global_position)
			<
			b.global_position.distance_squared_to(player.global_position)
		)
	)

	var sword_instance: Node2D = sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance)

	var enemy: Node2D = enemies[0] as Node2D
	sword_instance.global_position = enemy.global_position
	sword_instance.global_position += (
		Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * 4
	)

	var enemy_direction: Vector2 = (
		enemy.global_position - sword_instance.global_position
	)

	sword_instance.rotation = enemy_direction.angle()
