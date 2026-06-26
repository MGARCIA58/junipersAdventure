extends Sprite2D
class_name Player_Bullet
@export var speed := 300.0
@export var rotation_speed := 360.0
@export var sprites: Array[Texture2D]

var sting_damage: int = 0
var direction := Vector2.ZERO

func _ready():
	if !sprites.is_empty():
		texture = sprites.pick_random()
		
func _process(delta):
	global_position += direction * speed * delta
	rotation_degrees += rotation_speed * delta
	
func initialize(dir: Vector2):
	direction = dir
	#rotation = direction.angle()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	SoundManager.play_hit_fruit()
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	SoundManager.play_hit_fruit()
	queue_free()
	var parent = area.get_parent()
	if parent.is_in_group("enemy"):
		parent.hit_by_player(1)
		
