extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene: PackedScene = preload("res://scenes/ui/pause_menu.tscn")


func _ready() -> void:
	%Player.health_component.died.connect(_on_player_died)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		var pause_menu_instance: CanvasLayer = \
			pause_menu_scene.instantiate() as CanvasLayer
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


func _on_player_died() -> void:
	var end_screen_instance: EndScreen = (
		end_screen_scene.instantiate() as EndScreen
	)
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
