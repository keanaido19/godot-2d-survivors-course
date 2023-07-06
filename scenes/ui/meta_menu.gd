extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = %GridContainer
@onready var back_button = %BackButton

var meta_upgrade_card_scene: PackedScene = \
	preload("res://scenes/ui/meta_upgrade_card.tscn")


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)

	for upgrade in upgrades:

		var meta_upgrade_card: MetaUpgradeCard = \
			_create_meta_upgrade_card_instance()

		grid_container.add_child(meta_upgrade_card)
		meta_upgrade_card.set_meta_upgrade(upgrade)


func _create_meta_upgrade_card_instance() -> MetaUpgradeCard:
	return meta_upgrade_card_scene.instantiate() as MetaUpgradeCard


func _on_back_button_pressed() -> void:
	ScreenTransition.go_back_to_previous_scene()
