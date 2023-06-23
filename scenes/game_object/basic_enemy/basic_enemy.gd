extends CharacterBody2D
class_name BasicEnemy

const MAX_SPEED: float = 40.0

@onready var health_component: HealthComponent = $HealthComponent


func _process(delta):
	var direction: Vector2 = get_direction_to_player()
	self.velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	var player_node: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null != player_node:
		return (player_node.global_position - self.global_position).normalized()

	return Vector2.ZERO



