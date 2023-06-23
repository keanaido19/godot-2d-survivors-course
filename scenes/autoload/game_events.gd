extends Node


signal experience_vial_collected(amount: float)
signal player_level_up(level: int)
signal ability_upgrades_added(
	upgrade: AbilityUpgrade, current_upgrades: Dictionary
	)


func emit_experience_vial_collected(amount: float) -> void:
	experience_vial_collected.emit(amount)


func emit_ability_upgrade_added(
	upgrade: AbilityUpgrade, current_upgrades: Dictionary
) -> void:
	ability_upgrades_added.emit(upgrade, current_upgrades)


func emit_player_level_up(level: int):
	player_level_up.emit(level)
