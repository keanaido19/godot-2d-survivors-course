extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var animation_player = $AnimationPlayer
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
		card_instance.selected.connect(_on_upgrade_selected.bind(card_instance))
		await card_instance.show_card()

	enable_upgrade_cards()


func upgrade_cards_mapper(map_function: Callable) -> void:
	for child in card_container.get_children():
		if child is AbilityUpgradeCard:
			map_function.bind(child).call()


func enable_upgrade_cards() -> void:
	upgrade_cards_mapper(
		func(c:AbilityUpgradeCard): c.enable_card()
		)


func disable_upgrade_cards() -> void:
	upgrade_cards_mapper(
		func(c:AbilityUpgradeCard): c.disable_card()
		)

func discard_upgrade_cards() -> void:
	upgrade_cards_mapper(
		func(c:AbilityUpgradeCard): c.discard_card()
		)

func _on_upgrade_selected(card_instance: AbilityUpgradeCard):
	disable_upgrade_cards()
	discard_upgrade_cards()

	await card_instance.select_card()
	upgrade_selected.emit(card_instance.card_upgrade)

	animation_player.play("Out")
	await animation_player.animation_finished

	get_tree().paused = false
	queue_free()
