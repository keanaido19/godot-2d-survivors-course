extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	if health_component == null:
		push_error("HealthComponent is not assigned")
		return
	
	var hitbox_component: HitboxComponent = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
