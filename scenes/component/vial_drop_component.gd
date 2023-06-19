extends Node

@export_range(0.0, 1.0) var drop_percent: float = 0.5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene

func _ready() -> void:
	health_component.died.connect(_on_died)


func _on_died() -> void:
	if randf() > drop_percent:
		return
	
	if null == vial_scene || not owner is Node2D:
		return
	
	var spawn_position: Vector2 = (owner as Node2D).global_position
	var experience_vial: Node2D = vial_scene.instantiate() as Node2D
	owner.get_parent().add_child(experience_vial)
	experience_vial.global_position = spawn_position
	
