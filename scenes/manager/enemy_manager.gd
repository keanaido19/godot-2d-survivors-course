extends Node

const SPAWN_RADIUS: float = 330

@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var ghost_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var _timer: Timer = $Timer

var _base_spawn_time: float = 0.0
var player_level: int = 0
var enemy_table = WeightedTable.new()


func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
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

		var additional_check_offset: Vector2 = random_direction * 20

		var query_parameters: PhysicsRayQueryParameters2D = (
			PhysicsRayQueryParameters2D.create(
				player.global_position,
				spawn_position + additional_check_offset,
				1
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


func _on_player_level_up(level: int) -> void:
	player_level = level


func _on_timer_timeout() -> void:
	_timer.start()

	var player: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)

	if null == player:
		return

	var enemy_scene = enemy_table.pick_item()

	var enemy: Node2D = (
		enemy_scene.instantiate() as Node2D
	)

	var entities_layer: Node2D = (
		get_tree().get_first_node_in_group("entities_layer") as Node2D
	)

	if null == entities_layer:
		return

	entities_layer.add_child(enemy)

	var max_health: float = enemy.health_component.max_health
	enemy.health_component.set_max_health(
		max_health + ((max_health * 0.1 * player_level) * player_level / 3.7)
	)

	enemy.global_position = get_spawn_position()


func _on_arena_difficulty_increased(arena_difficulty: int) -> void:
	var time_off: float = (0.1 / 12) * arena_difficulty
	time_off = min(time_off, _base_spawn_time - 0.001)
	_timer.wait_time = _base_spawn_time - time_off
	print_debug("Time off: " + str(time_off))

	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 20)
	
	if arena_difficulty == 35:
		enemy_table.add_item(ghost_enemy_scene, 18)
