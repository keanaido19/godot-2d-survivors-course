extends Node

const SPAWN_RADIUS: float = 330

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var _timer: Timer = $Timer

var _base_spawn_time: float = 0.0
var player_level: int = 0


func _ready() -> void:
	GameEvents.player_level_up.connect(_on_player_level_up)

	_base_spawn_time = _timer.wait_time
	_timer.connect("timeout", _on_timer_timeout)

	arena_time_manager.arena_difficulty_increased.connect(
		_on_arena_difficulty_increased
	)


func get_spawn_position() -> Vector2:
	var player: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null == player:
		return Vector2.ZERO
	
	var spawn_position: Vector2 = Vector2.ZERO
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		
		spawn_position = (
			player.global_position + (random_direction * SPAWN_RADIUS)
		)
		
		var query_parameters: PhysicsRayQueryParameters2D = (
			PhysicsRayQueryParameters2D.create(
				player.global_position, spawn_position, 1
			)
		)
		var result: Dictionary = (
			get_tree().root.world_2d.direct_space_state.intersect_ray(
				query_parameters
			)
		)
	
		if result.is_empty():
			break
		
		random_direction = random_direction.rotated(PI / 2)
		
	return spawn_position


func _on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off: float = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, _base_spawn_time - 0.001)
	_timer.wait_time = _base_spawn_time - time_off
	print_debug("Time off: " + str(time_off))


func _on_timer_timeout() -> void:
	_timer.start()

	var player: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null == player:
		return

	var basic_enemy: BasicEnemy = (
		basic_enemy_scene.instantiate() as BasicEnemy
	)

	var entities_layer: Node2D = (
		get_tree().get_first_node_in_group("entities_layer") as Node2D
	)

	if null == entities_layer:
		return

	entities_layer.add_child(basic_enemy)

	var max_health: float = basic_enemy.health_component.max_health
	basic_enemy.health_component.set_max_health(
		max_health + ((max_health * 0.1 * player_level) * player_level / 3)
	)

	basic_enemy.global_position = get_spawn_position()


func _on_player_level_up(level: int) -> void:
	player_level = level
