extends Node2D
class_name Game

@onready var player: Player = $Player
@onready var spawn_pos: Marker2D = $SpawnPos
@onready var checkpoint_respawn_pos: Marker2D = $checkpointRespawnPos
@onready var game_won_panel: Panel = %GameWonPanel
@onready var points_label: Label = %Points
@onready var health_points_label: Label = $GameUI/Control2/HealthPoints

var health_points: int = 10
var points: int
var checkpoint_reached: bool

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_dead)
	EventManager.on_fruit_collected.connect(_on_fruit_collected)
	EventManager.on_checkpoint_reached.connect(_on_checkpoint_reached)
	EventManager.on_game_won.connect(_on_game_won)
	EventManager.on_player_damage.connect(_on_player_damage)
	EventManager.on_health_collected.connect(_on_health_collected)
	health_points_label.text = str(health_points)
	
func get_respawn_pos() -> Vector2:
	if checkpoint_reached:
		return checkpoint_respawn_pos.position
	else:
		return spawn_pos.position

func _on_player_damage(damage) -> void:
	health_points -=damage
	player.player_damage()
	if health_points <= 0:
		health_points = 0
		_on_player_dead()
	health_points_label.text = str(health_points)

func _on_player_dead() -> void:
	player.player_dead()
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(player, "global_position", get_respawn_pos(), 0.5)
	tween.tween_callback(player.player_respawn)
	
func _on_health_collected() -> void:
	health_points += 1
	health_points_label.text = str(health_points)
	
func _on_fruit_collected() -> void:
	points += 1
	points_label.text = str(points)

func _on_checkpoint_reached() -> void:
	checkpoint_reached = true
	
func _on_game_won() -> void:
	game_won_panel.show()


func _on_play_button_pressed() -> void:
	get_tree().reload_current_scene()
