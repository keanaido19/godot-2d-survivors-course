extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D

var xp_amount: int = 1


func _ready():
	$Area2D.connect("area_entered", _on_area_entered)


func tween_collect(percent: float, start_position: Vector2) -> void:
	var player: Player = (
		get_tree().get_first_node_in_group("player") as Player
	)

	if null == player:
		return

	global_position = start_position.lerp(player.global_position, percent)

	var target_rotation: float = \
	(player.global_position - start_position).angle() + (PI / 2)

	rotation = lerp_angle(
		rotation,
		target_rotation,
		1.0 - exp(-2.0 * get_process_delta_time())
	)

func collect() -> void:
	GameEvents.emit_experience_vial_collected(xp_amount)
	queue_free()


func disable_collision() -> void:
	collision_shape_2d.disabled = true


func _on_area_entered(area: Area2D):
	Callable(disable_collision).call_deferred()

	var tween: Tween = create_tween()

	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
		 .set_ease(Tween.EASE_IN)\
		 .set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
	tween.chain()
	tween.tween_callback(collect)

