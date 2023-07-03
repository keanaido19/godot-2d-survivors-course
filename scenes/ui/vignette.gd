extends CanvasLayer

@onready var animation_player = $AnimationPlayer



func _ready() -> void:
	GameEvents.player_damaged.connect(_on_player_damaged)


func _on_player_damaged() -> void:
	animation_player.play("hit")
