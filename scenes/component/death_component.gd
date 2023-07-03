extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D


func _ready() -> void:
	$GPUParticles2D.texture = sprite.texture
	health_component.died.connect(_on_died)


func _on_died() -> void:
	if not owner is Node2D:
		return

	var spawn_position = owner.global_position
	var entities_layer: Node2D = (
		get_tree().get_first_node_in_group("entities_layer")
	)

	get_parent().remove_child(self)
	entities_layer.add_child(self)
	global_position = spawn_position

	($GPUParticles2D.material as ShaderMaterial)\
		.set_shader_parameter("lerp_percent", 1.0)

	var tween: Tween = create_tween()

	tween.tween_property(
		$GPUParticles2D.material, "shader_parameter/lerp_percent", 0.0 , 0.25
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

	$AnimationPlayer.play("default")
	$RandomAudioStreamPlayer2D.play_random()

