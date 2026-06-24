extends Area2D
class_name Checkpoint

@onready var rea: AnimatedSprite2D = $rea



func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	rea.play("reached")
	EventManager.on_checkpoint_reached.emit()
