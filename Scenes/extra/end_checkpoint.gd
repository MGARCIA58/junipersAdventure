extends Area2D
class_name EndCheckpoint


func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
		
	EventManager.on_game_won.emit()
