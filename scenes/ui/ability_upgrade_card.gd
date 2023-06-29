extends PanelContainer
class_name AbilityUpgradeCard

signal selected
signal animation_done

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel


func _ready() -> void:
	modulate = Color.TRANSPARENT
	gui_input.connect(_on_gui_input)


func play_in() -> void:
	$AnimationPlayer.play("In")

func emit_animation_done() -> void:
	animation_done.emit()


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()
