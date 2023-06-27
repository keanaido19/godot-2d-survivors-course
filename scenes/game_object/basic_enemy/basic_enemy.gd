extends CharacterBody2D
class_name BasicEnemy

@onready var visuals: Node2D= $Visuals
@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var direction_sign: int = sign(velocity.x)
	if  direction_sign != 0:
		visuals.scale = Vector2(direction_sign, 1.0)
