extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer


func _ready() -> void:
	get_tree().paused = true


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	for upgrade in upgrades:

		var card_instance: AbilityUpgradeCard = (
			upgrade_card_scene.instantiate() as AbilityUpgradeCard
		)

		card_container.add_child(card_instance)

		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(_on_upgrade_selected.bind(upgrade))
		card_instance.play_in()
		await card_instance.animation_done


func _on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
