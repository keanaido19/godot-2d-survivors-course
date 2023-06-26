extends Node


signal experience_vial_collected(amount: float)
signal player_level_up(level: int)
signal ability_upgrade_added(upgrade: AbilityUpgrade)
signal player_upgrades_changed()

var player_upgrades: Dictionary = {}


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
	
	ability_upgrade_added.emit(upgrade)
	emit_player_upgrades_changed()


func emit_player_level_up(level: int):
	player_level_up.emit(level)
