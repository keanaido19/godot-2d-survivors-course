extends Node

@export var axe_ability_scene: PackedScene

var damage: float = 13
var base_wait_time: float


func _ready() -> void:
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var player: Player = (
		get_tree().get_first_node_in_group("player") as Player
	)

	if null == player:
		return

	var foreground_layer: Node2D = (
		get_tree().get_first_node_in_group("foreground_layer") as Node2D
	)

	if null == foreground_layer:
		return

	var axe_ability_instance: AxeAbility = (
		axe_ability_scene.instantiate() as AxeAbility
	)

	foreground_layer.add_child(axe_ability_instance)
	axe_ability_instance.tracking_node = player
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage = damage


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, quantity: int) -> void:
	if upgrade.id == "axe_rate":
		var percent_reduction: float = quantity * 0.1
		$Timer.wait_time = base_wait_time * max(1 - percent_reduction, 0.001)
		$Timer.start()
	elif upgrade.id == "axe_damage":
		damage += roundf(damage * 0.15)
