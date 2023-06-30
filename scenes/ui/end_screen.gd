extends CanvasLayer
class_name EndScreen

@onready var panel_container = %PanelContainer


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2

	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func set_defeat() -> void:
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lose!"


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
