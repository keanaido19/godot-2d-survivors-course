extends AudioStreamPlayer


func _ready() -> void:
	finished.connect(_on_music_player_finished)
	$Timer.timeout.connect(_on_timer_timeout)


func _on_music_player_finished() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	play()
