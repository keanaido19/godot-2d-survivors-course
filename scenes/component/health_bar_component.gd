extends ProgressBar
class_name HealthBar

@export var health_component: HealthComponent
@export var color_gradient: Gradient


func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	update_health_display()



func update_health_display() -> void:
	var health_percent: float = health_component.get_health_percent()
	self.value = health_percent
	get_theme_stylebox("fill").bg_color = color_gradient.sample(health_percent)



func _on_health_changed() -> void:
	update_health_display()
