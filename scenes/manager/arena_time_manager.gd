extends Node


@onready var _timer: Timer = $Timer


func get_time_elapsed() -> float:
	return _timer.wait_time - _timer.time_left
