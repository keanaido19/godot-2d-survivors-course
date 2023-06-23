extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL: float = 5.0

@export var end_screen_scene: PackedScene

@onready var _timer: Timer = $Timer

var arena_difficulty: int = 0

func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)


func _process(delta: float) -> void:
	var next_time_target: float = (
		_timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	)

	if _timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
		print_debug("Arena Difficulty: " + str(arena_difficulty))


func get_time_elapsed() -> float:
	return _timer.wait_time - _timer.time_left


func _on_timer_timeout() -> void:
	var end_screen_instance: EndScreen = (
		end_screen_scene.instantiate() as EndScreen
	)

	get_parent().add_child(end_screen_instance)
