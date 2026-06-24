extends StaticBody2D
class_name MovingRock

@export var reset_timer := 0.5
@export var move_distance :float
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	
func move_bottom() -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position:y", start_position.y + move_distance, 0.5)
	tween.tween_interval(reset_timer)
	tween.tween_property(self, "global_position:y",start_position.y, 0.5)


func _on_action_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	move_bottom()


func _on_kill_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	EventManager.on_player_dead.emit()
