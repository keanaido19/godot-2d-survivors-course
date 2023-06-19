extends CanvasLayer

@export var experience_manager: ExperienceManager

@onready var progress_bar: ProgressBar = %ProgressBar


func _ready() -> void:
	progress_bar.value = 0.0
	if null == experience_manager:
		push_error("ExperienceManager is not assigned")
		return
	
	experience_manager.experience_updated.connect(_on_experience_updated)


func _on_experience_updated(
	current_experience: float, target_experience: float
) -> void:
	progress_bar.value = current_experience / target_experience
