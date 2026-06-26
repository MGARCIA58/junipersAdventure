extends Area2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var collected := false


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	
	collected = true
	anim_sprite.play("collected")
	EventManager.on_health_collected.emit()
	await get_tree().create_timer(0.5).timeout
	queue_free()
