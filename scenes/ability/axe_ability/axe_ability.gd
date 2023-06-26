extends Node2D
class_name AxeAbility

const MAX_RADIUS: float = 135.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var tracking_node: Node2D
var base_rotation: Vector2 = Vector2.RIGHT


func _ready() -> void:
	base_rotation  = Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	
	var tween: Tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3.0)
	tween.tween_callback(queue_free)


func tween_method(rotations: float) -> void:
	var current_radius: float = (rotations / 2) * MAX_RADIUS
	var current_direction: Vector2 = base_rotation.rotated(rotations * TAU)

	if null == tracking_node:
		return
	
	global_position = tracking_node.global_position + (current_direction * current_radius)
