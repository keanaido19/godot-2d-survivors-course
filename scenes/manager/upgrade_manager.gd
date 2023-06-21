extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen: PackedScene
@export var upgrade_pool: Array[AbilityUpgrade]

var current_upgrades: Dictionary = {}


func _ready() -> void:
	if null == experience_manager:
		push_error("ExperienceManager is not assigned")
		return
	
	experience_manager.level_up.connect(_on_level_up)


func _on_level_up(current_level: int) -> void:
	var chosen_upgrade: AbilityUpgrade = (
		upgrade_pool.pick_random() as AbilityUpgrade
	)
	
	if null == chosen_upgrade:
		return
	
	var upgrade_screen_instance: UpgradeScreen = (
		upgrade_screen.instantiate() as UpgradeScreen
	)
	
	self.add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade])


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: bool = current_upgrades.has(upgrade.id)
	
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	print_debug(current_upgrades)
