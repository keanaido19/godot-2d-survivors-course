extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

var floating_text_scene = preload("res://scenes/ui/floating_text.tscn")


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return

	if health_component == null:
		push_error("HealthComponent is not assigned")
		return

	var hitbox_component: HitboxComponent = area as HitboxComponent
	health_component.damage(hitbox_component.damage)

	var floating_text = floating_text_scene.instantiate() as Node2D

	get_tree().get_first_node_in_group("foreground_layer")\
	.add_child(floating_text)

	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(hitbox_component.damage))
