extends PathFollow2D
class_name CustomPathFollow

@export var move_speed := 0.5

var direction := 1
var can_move := true

func _process(delta: float) -> void:
	if not can_move:
		return
	
	progress_ratio += move_speed * direction * delta
	
	if progress_ratio >= 1:
		direction =-1
	elif progress_ratio <= 0:
		direction = 1
