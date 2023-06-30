extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animation_player = $AnimationPlayer

var card_upgrade: AbilityUpgrade:
	set(upgrade) :
		card_upgrade = upgrade
		name_label.text = upgrade.name
		description_label.text = upgrade.description

var _is_selected: bool = false

enum CardAnimation{
	In, Selected, Discard
}

var card_animation_lookup: Dictionary = {
	CardAnimation.In: "In",
	CardAnimation.Selected: "Selected",
	CardAnimation.Discard: "Discard"
}


func _ready() -> void:
	modulate = Color.TRANSPARENT


func enable_card() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)


func disable_card() -> void:
	gui_input.disconnect(_on_gui_input)
	mouse_entered.disconnect(_on_mouse_entered)


func discard_card() -> void:
	if not _is_selected:
		await play_card_animation(CardAnimation.Discard)


func select_card() -> void:
	await play_card_animation(CardAnimation.Selected)


func show_card() -> void:
	await play_card_animation(CardAnimation.In)


func play_card_animation(card_animation: CardAnimation) -> void:
	animation_player.play(card_animation_lookup[card_animation])
	await animation_player.animation_finished


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	card_upgrade = upgrade


func _on_gui_input(event: InputEvent) -> void:
	if not event.is_action_pressed("left_click"):
		return

	_is_selected = true
	selected.emit()


func _on_mouse_entered() -> void:
	$HoverAnimationPlayer.play("Hover")
