extends Node2D

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game/game.tscn")
	SoundManager.play_music()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_intro()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_draw() -> void:
	pass # Replace with function body.
