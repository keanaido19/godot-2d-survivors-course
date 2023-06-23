extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10.0

var current_health: float


func _ready() -> void:
	current_health = max_health


func set_max_health(new_max_health: float):
	max_health = new_max_health
	current_health = max_health


func damage(amount: float) -> void:
	current_health = max(current_health - amount, 0.0)
	health_changed.emit()
	Callable(_check_death).call_deferred()


func get_health_percent() -> float:
	if max_health <= 0.0:
		return 0.0

	return min(current_health / max_health, 1.0)


func _check_death() -> void:
	if 0 == current_health:
		died.emit()
		owner.queue_free()
