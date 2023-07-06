extends CanvasLayer
class_name EndScreen

@onready var panel_container = %PanelContainer

var _is_victory: bool = true


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2

	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	%ContinueButton.pressed.connect(_on_continue_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func set_defeat() -> void:
	_is_victory = false
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lose!"


func play_jingle() -> void:
	if _is_victory:
		$VictoryStreamPlayer.play()
	else:
		$DefeatStreamPlayer.play()


func _on_continue_button_pressed() -> void:
	await ScreenTransition.transition_to_scene(
		"res://scenes/main/main.tscn", "res://scenes/ui/meta_menu.tscn"
	)
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	await ScreenTransition.transition_to_scene(
		"", "res://scenes/ui/main_menu.tscn"
		)
	get_tree().paused = false
