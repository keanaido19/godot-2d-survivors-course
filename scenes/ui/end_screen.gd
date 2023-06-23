extends CanvasLayer
class_name EndScreen


func _ready() -> void:
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
