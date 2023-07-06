extends CanvasLayer

@onready var margin_container = $MarginContainer
@onready var panel_container = %PanelContainer

var options_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%UpgradesButton.pressed.connect(_on_upgrades_button_pressed)
	%OptionsButton.pressed.connect(_on_options_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func fade_in() -> void:
	margin_container.visible = true


func fade_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(margin_container, "visible", false, 0.0)

	await tween.finished
	await get_tree().create_timer(0.1).timeout


func _on_play_button_pressed() -> void:
	await fade_out()
	ScreenTransition.transition_to_scene(
		scene_file_path, "res://scenes/main/main.tscn"
		)


func _on_upgrades_button_pressed() -> void:
	await fade_out()
	ScreenTransition.transition_to_scene(
		scene_file_path, "res://scenes/ui/meta_menu.tscn"
		)


func _on_options_button_pressed() -> void:
	await fade_out()

	var options_instance: CanvasLayer = \
		options_scene.instantiate() as CanvasLayer
	add_child(options_instance)
	options_instance.back_button_pressed.connect(
		_on_options_closed.bind(options_instance)
		)


func _on_options_closed(options_instance: CanvasLayer) -> void:
	await options_instance.fade_out()
	Callable(options_instance, "queue_free").call_deferred()
	fade_in()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
