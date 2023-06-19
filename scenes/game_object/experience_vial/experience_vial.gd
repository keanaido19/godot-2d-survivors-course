extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", _on_area_entered)


func _on_area_entered(area: Area2D):
	queue_free()
