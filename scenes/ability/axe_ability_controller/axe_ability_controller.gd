extends Node

@export var axe_ability_scene: PackedScene

var damage: float = 13


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)


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

