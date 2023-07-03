extends CharacterBody2D
class_name BasicEnemy

@onready var visuals: Node2D= $Visuals
@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var random_audio_stream_player_2d = $RandomAudioStreamPlayer2D


func _ready() -> void:
	hurtbox_component.hit.connect(_on_hit)


func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	var direction_sign: int = sign(velocity.x)
	if  direction_sign != 0:
		visuals.scale = Vector2(direction_sign, 1.0)


func _on_hit() -> void:
	random_audio_stream_player_2d.play_random()
