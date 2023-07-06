extends CanvasLayer

signal transitioned_halfway

@onready var color_rect = $ColorRect

var should_skip_emit: bool = false
var scene_paths: Array[String] = []


func _ready() -> void:
	color_rect.visible = false


func transition_to_scene(current_scene: String, new_scene: String) -> void:
	if current_scene != null || not current_scene.is_empty():
		scene_paths.append(current_scene)

	transition()
	await transitioned_halfway
	get_tree().change_scene_to_file(new_scene)


func go_back_to_previous_scene() -> void:
	var previous_scene = scene_paths.pop_back()
	if null == previous_scene: return
	transition_to_scene("", previous_scene)


func transition() -> void:
	$AnimationPlayer.play("default")
	await transitioned_halfway
	$AnimationPlayer.play_backwards("default")


func change_visibilty() -> void:
	color_rect.visible = not color_rect.visible


func emit_transitioned_halfway() -> void:
	if should_skip_emit:
		should_skip_emit = false
		return

	should_skip_emit = true
	transitioned_halfway.emit()
