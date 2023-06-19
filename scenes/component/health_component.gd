extends Node
class_name HealthComponent

signal died

@export var max_health: float = 10.0

var _current_health: float


func _ready() -> void:
	_current_health = max_health


func damage(amount: float) -> void:
	_current_health = max(_current_health - amount, 0.0)
	Callable(_check_death).call_deferred()


func _check_death() -> void:
	if 0 == _current_health:
		died.emit()
		owner.queue_free()
