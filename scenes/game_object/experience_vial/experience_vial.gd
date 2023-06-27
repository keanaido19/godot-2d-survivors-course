extends Node2D

var xp_amount: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", _on_area_entered)


func _on_area_entered(area: Area2D):
	GameEvents.emit_experience_vial_collected(xp_amount)
	queue_free()
