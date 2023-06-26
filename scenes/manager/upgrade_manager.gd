extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen: PackedScene
@export var upgrade_pool: Array[AbilityUpgrade]


func _ready() -> void:
	experience_manager.level_up.connect(_on_level_up)
	GameEvents.upgrade_pool_updated.connect(_on_upgrade_pool_updated)

	for upgrade in upgrade_pool:
		GameEvents.add_upgrade_to_upgrade_pool(upgrade)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	GameEvents.emit_ability_upgrade_added(upgrade)

func pick_unique_upgrades(amount: int = 3) -> Array[AbilityUpgrade]:
	assert(amount > 0)

	var chosen_upgrades: Array[AbilityUpgrade] = []

	if upgrade_pool.is_empty():
		return chosen_upgrades

	var filtered_upgrades: Array[AbilityUpgrade] = upgrade_pool.duplicate()

	for i in amount:
		if filtered_upgrades.is_empty():
			break

		var chosen_upgrade: AbilityUpgrade = (
			filtered_upgrades.pick_random()
		)

		filtered_upgrades = (
			filtered_upgrades.filter(func (upgrade):
				return upgrade != chosen_upgrade
				)
			)

		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades


func _on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func _on_level_up(current_level: int) -> void:
	var chosen_upgrades: Array[AbilityUpgrade] = pick_unique_upgrades()

	if chosen_upgrades.is_empty():
		return

	var upgrade_screen_instance: UpgradeScreen = (
		upgrade_screen.instantiate() as UpgradeScreen
	)

	self.add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)


func _on_upgrade_pool_updated(updated_upgrade_pool: Array[AbilityUpgrade]) -> void:
	upgrade_pool = updated_upgrade_pool
