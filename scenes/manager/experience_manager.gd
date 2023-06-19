extends Node
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH: float = 5

var current_experience: float = 0.0
var current_level: float = 1.0
var target_experience: float = 5.0


func _ready():
	GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)


func increment_experience(amount: float) -> void:
	current_experience = min(current_experience + amount, target_experience)
	experience_updated.emit(current_experience, target_experience)
	
	if current_experience == target_experience:
		current_level += 1.0
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0.0
		experience_updated.emit(current_experience, target_experience)


func _on_experience_vial_collected(amount: float):
	increment_experience(amount)
