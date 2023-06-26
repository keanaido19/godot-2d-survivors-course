extends Node

const MAX_RANGE: float = 80.0

@export var sword_ability: PackedScene

var damage: float = 6.0
var base_wait_time: float


func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.connect("timeout", _on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


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

	var sword_instance: SwordAbility = (
		sword_ability.instantiate() as SwordAbility
	)

	var foreground_layer: Node2D = (
		get_tree().get_first_node_in_group("foreground_layer")
		as
		Node2D
	)

	if null == foreground_layer:
		return

	foreground_layer.add_child(sword_instance)
	sword_instance.hitbox_component.damage = damage

	var enemy: Node2D = enemies[0] as Node2D
	sword_instance.global_position = enemy.global_position
	sword_instance.global_position += (
		Vector2.RIGHT.rotated(randf_range(0.0, TAU)) * 4
	)

	var enemy_direction: Vector2 = (
		enemy.global_position - sword_instance.global_position
	)

	sword_instance.rotation = enemy_direction.angle()


func _on_ability_upgrade_added(upgrade: AbilityUpgrade) -> void:
	if upgrade.id != "sword_rate":
		return
	
#	var percent_reduction: float = (
#		current_upgrades["sword_rate"]["quantity"] * 0.1
#	)
#
#	$Timer.wait_time = base_wait_time * max(1 - percent_reduction, 0.001)
#	$Timer.start()
#	print_debug("Sword attack rate: " + str($Timer.wait_time) + "s")
