extends CanvasLayer

signal back_button_pressed

@onready var sfx_slider = %SFXSlider
@onready var music_slider = %MusicSlider
@onready var window_mode_option_button = %WindowModeOptionButton
@onready var back_button = %BackButton
@onready var panel_container = %PanelContainer


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2

	back_button.pressed.connect(_on_back_button_pressed)
	window_mode_option_button.item_selected.connect(_on_window_mode_selected)

	sfx_slider.value_changed.connect(
		_on_audio_slider_changed.bind("sfx")
		)

	music_slider.value_changed.connect(
		_on_audio_slider_changed.bind("music")
		)

	_update_display()


func fade_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0)
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

	await tween.finished
	await get_tree().create_timer(0.1).timeout


func _update_display() -> void:
	_on_window_mode_selected(window_mode_option_button.selected)
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")



func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(volume_percent: float, bus_name: String) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var volume_db: float = linear_to_db(volume_percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)


func _on_back_button_pressed() -> void:
	back_button_pressed.emit()


func _on_audio_slider_changed(volume_percent: float, bus_name: String) -> void:
	set_bus_volume_percent(volume_percent, bus_name)


func _on_window_mode_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
