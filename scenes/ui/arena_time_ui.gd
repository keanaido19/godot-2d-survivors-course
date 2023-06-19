extends CanvasLayer


@export var arena_time_manager: Node

@onready var label: Label = %Label


func _process(delta: float) -> void:
	if null == arena_time_manager:
		return

	var time_elapsed: float = floorf(
		arena_time_manager.get_time_elapsed()
	)

	label.text = _format_seconds_to_string(time_elapsed)


func _format_seconds_to_string(seconds: float) -> String:
	var minutes: int = floor(seconds / 60)
	var remaining_seconds: float = seconds - (minutes * 60)
	return str(minutes) + ":" + ("%02d" % floor(remaining_seconds))
