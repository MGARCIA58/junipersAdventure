extends AnimatableBody2D
class_name Yellow_Obstacle_1
var base_rotation := 0.0
var target_rotation := 0.0
func _ready() -> void:
	base_rotation = rotation
	EventManager.rotate_yellow_obstacles.connect(_rotate_obstacle)

func _rotate_obstacle(new_rotation: float) -> void:
	target_rotation += new_rotation
	rotation = base_rotation + target_rotation
	
