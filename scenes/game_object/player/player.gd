extends CharacterBody2D
class_name Player

const MAX_SPEED: float = 125.0
const ACCELERATION_SMOOTHING: float = 25.0

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var abilities: Node = $Abilities

var number_colliding_bodies: int = 0


func _ready() -> void:
	$CollisionArea2D.body_entered.connect(_on_body_entered)
	$CollisionArea2D.body_exited.connect(_on_body_exited)
	damage_interval_timer.timeout.connect(_on_damage_interval_timer_timeout)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _process(delta):
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized();

	var target_velocity: Vector2 = direction * MAX_SPEED

	self.velocity = (
		velocity.lerp(
			target_velocity, 1.0 - exp(-delta * ACCELERATION_SMOOTHING)
		)
	)
	
	move_and_slide()


func get_movement_vector() -> Vector2:
	var x_movement: float = (
		Input.get_action_strength("move_right")
		-
		Input.get_action_strength("move_left")
	)

	var y_movement: float = (
		Input.get_action_strength("move_down")
		-
		Input.get_action_strength("move_up")
	)

	return Vector2(x_movement, y_movement)


func check_deal_damage() -> void:
	if 0 == number_colliding_bodies || not damage_interval_timer.is_stopped():
		return

	health_component.damage(1.0)
	damage_interval_timer.start()
	print_debug(health_component.current_health)

func _on_body_entered(body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func _on_body_exited(body: Node2D) -> void:
	number_colliding_bodies = max(number_colliding_bodies - 1, 0)


func _on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func _on_ability_upgrade_added(upgrade: AbilityUpgrade) -> void:
	if upgrade is Ability:
		abilities.add_child(upgrade.ability_controller_scene.instantiate())
