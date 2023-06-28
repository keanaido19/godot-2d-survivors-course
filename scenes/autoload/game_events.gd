extends Node


signal experience_vial_collected(amount: float)
signal player_level_up(level: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade, quantity: int)
signal player_upgrades_changed()
signal upgrade_pool_updated(upgrade_pool: Array[AbilityUpgrade])

var player_upgrades: Dictionary = {}
var upgrade_pool: Array[AbilityUpgrade] = []

func emit_experience_vial_collected(amount: float) -> void:
	experience_vial_collected.emit(amount)


func emit_player_upgrades_changed() -> void:
	player_upgrades_changed.emit()


func emit_ability_upgrade_added(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: bool = player_upgrades.has(upgrade.id)

	if not has_upgrade:
		player_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		player_upgrades[upgrade.id]["quantity"] += 1

	if upgrade is Ability:
		for ability in upgrade.ability_upgrades:
			add_upgrade_to_upgrade_pool(ability)

	if (
		upgrade.max_quantity != 0
		&&
		player_upgrades[upgrade.id]["quantity"] >= upgrade.max_quantity
	):
		remove_upgrade_from_upgrade_pool(upgrade)

	ability_upgrade_added.emit(upgrade, player_upgrades[upgrade.id]["quantity"])
	emit_player_upgrades_changed()


func emit_player_level_up(level: int):
	player_level_up.emit(level)


func emit_upgrade_pool_updated():
	upgrade_pool_updated.emit(upgrade_pool)


func check_upgrade_pool_contains_upgrade(upgrade: AbilityUpgrade) -> bool:
	return upgrade_pool.any(
		func(pool_upgrade): return pool_upgrade.id == upgrade.id
	)


func add_upgrade_to_upgrade_pool(ability_upgrade: AbilityUpgrade) -> void:
	if check_upgrade_pool_contains_upgrade(ability_upgrade):
		return

	upgrade_pool.append(ability_upgrade)
	emit_upgrade_pool_updated()


func remove_upgrade_from_upgrade_pool(ability_upgrade: AbilityUpgrade) -> void:
	if not check_upgrade_pool_contains_upgrade(ability_upgrade):
		return

	upgrade_pool = upgrade_pool.filter(
		func(pool_upgrade): return pool_upgrade.id != ability_upgrade.id
		)

	emit_upgrade_pool_updated()

