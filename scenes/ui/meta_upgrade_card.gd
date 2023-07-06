extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = %ProgressBar
@onready var progress_label = %ProgressLabel
@onready var purchase_button = %PurchaseButton
@onready var count_label = %CountLabel

var max_xp: float = 0

var available_xp: float:
	get:
		return MetaProgression.save_data["meta_upgrade_currency"]

var card_upgrade: MetaUpgrade:
	set(upgrade) :
		card_upgrade = upgrade
		name_label.text = upgrade.title
		description_label.text = upgrade.description
		max_xp = upgrade.experience_cost

var _is_selected: bool = false

enum CardAnimation{
	Selected
}

var card_animation_lookup: Dictionary = {
	CardAnimation.Selected: "Selected"
}


func _ready() -> void:
	enable_card()


func update_progress() -> void:
	var percent: float = \
		0.0 if max_xp == 0 else minf(available_xp / max_xp, 1.0)

	var tween: Tween = create_tween()
	tween.tween_property(progress_bar, "value", percent, 1.0)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	progress_label.text = str(available_xp) + "/" + str(max_xp)

	var quantity: int = \
		MetaProgression.save_data["meta_upgrades"][card_upgrade.id]["quantity"]\
		if MetaProgression.save_data["meta_upgrades"].has(card_upgrade.id) \
		else 0

	count_label.text = "x%d" % quantity

	var is_max_quantity: bool = quantity >= card_upgrade.max_quantity

	purchase_button.text = "Purchase" if not is_max_quantity else "Max"

	purchase_button.disabled = available_xp < max_xp || is_max_quantity



func enable_card() -> void:
	MetaProgression.meta_upgrade_currency_changed.connect(
		_on_meta_upgrade_currency_changed
		)
	purchase_button.pressed.connect(_on_purchase_button_pressed)


func disable_card() -> void:
	purchase_button.pressed.disconnect(_on_purchase_button_pressed)
	MetaProgression.meta_upgrade_currency_changed.disconnect(
		_on_meta_upgrade_currency_changed
		)


func select_card() -> void:
	_is_selected = true
	await play_card_animation(CardAnimation.Selected)


func play_card_animation(card_animation: CardAnimation) -> void:
	animation_player.play(card_animation_lookup[card_animation])
	await animation_player.animation_finished


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	card_upgrade = upgrade
	update_progress()


func _on_purchase_button_pressed() -> void:
	if null == card_upgrade:
		return
	select_card()
	MetaProgression.purchase_meta_upgrade(card_upgrade)


func _on_meta_upgrade_currency_changed() -> void:
	update_progress()

