extends Node

@export_range(0, 10, 1) var xp_amount: int = 1
@export_range(0.0, 1.0) var drop_percent: float = 0.5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(_on_died)


func _on_died() -> void:
	var adjusted_drop_percent: float = drop_percent

	var experience_gain_upgrade_count = \
		MetaProgression.get_meta_upgrade_amount("experience_gain")

	adjusted_drop_percent += (experience_gain_upgrade_count * 0.1)

	if randf() > adjusted_drop_percent:
		return

	if null == vial_scene || not owner is Node2D:
		return

	var spawn_position: Vector2 = (owner as Node2D).global_position
	var experience_vial: Node2D = vial_scene.instantiate() as Node2D
	var entities_layer: Node2D = (
		get_tree().get_first_node_in_group("entities_layer") as Node2D
	)

	if null == entities_layer:
		return

	entities_layer.add_child(experience_vial)
	experience_vial.xp_amount = xp_amount
	experience_vial.global_position = spawn_position

