extends CharacterBody2D


const MAX_SPEED: float = 75.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction: Vector2 = get_direction_to_player()
	self.velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	var player_node: CharacterBody2D = (
		get_tree().get_first_node_in_group("player") as CharacterBody2D
	)
	
	if null != player_node:
		return (player_node.global_position - self.global_position).normalized()
		
	return Vector2.ZERO


func  _on_area_entered(area: Area2D):
	queue_free()
