extends Sprite2D
class_name Plant_Bullet
@export var speed := 300.0

var ball_damage: int = 0
var direction := Vector2.ZERO

func _process(delta):
	global_position += direction * speed * delta
	
func initialize(dir: Vector2):
	direction = dir
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		EventManager.on_player_damage.emit(ball_damage)
	
	queue_free()
