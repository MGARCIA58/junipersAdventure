extends Sprite2D
class_name Bee_Bullet
@export var speed := 300.0

var sting_damage: int = 0
var direction := Vector2.ZERO

func _process(delta):
	global_position += direction * speed * delta
	
func initialize(dir: Vector2):
	direction = dir
	rotation = direction.angle()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		EventManager.on_player_damage.emit(sting_damage)
	
	queue_free()
