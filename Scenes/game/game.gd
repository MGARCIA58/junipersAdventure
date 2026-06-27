extends Node2D
class_name Game

@onready var player: Player = $Player
@onready var spawn_pos: Marker2D = $SpawnPos
@onready var checkpoint_respawn_pos: Marker2D = $checkpointRespawnPos
@onready var game_won_panel: Panel = %GameWonPanel
@onready var points_label: Label = %Points
@onready var health_points_label: Label = $GameUI/Control2/HealthPoints
@onready var node: Node2D = %Node
@onready var end_checkpoint: EndCheckpoint = %EndCheckpoint
@onready var health_coin: Area2D = $Levels/Level5/Node/healthCoin
@onready var health_coin_2: Area2D = $Levels/Level5/Node/healthCoin2
@onready var health_coin_3: Area2D = $Levels/Level5/Node/healthCoin3
@onready var health_coin_4: Area2D = $Levels/Level5/Node/healthCoin4
@onready var health_coin_5: Area2D = $Levels/Level5/Node/healthCoin5
@onready var health_coin_6: Area2D = $Levels/Level5/Node/healthCoin6
@onready var health_coin_7: Area2D = $Levels/Level5/Node/healthCoin7
@onready var health_coin_8: Area2D = $Levels/Level5/Node/healthCoin8
@onready var health_coin_9: Area2D = $Levels/Level5/Node/healthCoin9
@onready var health_coin_10: Area2D = $Levels/Level5/Node/healthCoin10
@onready var health_coin_11: Area2D = $Levels/Level5/Node/healthCoin11
@onready var health_coin_12: Area2D = $Levels/Level5/Node/healthCoin12
@onready var health_coin_13: Area2D = $Levels/Level5/Node/healthCoin13
@onready var health_coin_14: Area2D = $Levels/Level5/Node/healthCoin14
@onready var health_coin_15: Area2D = $Levels/Level5/Node/healthCoin15
@onready var health_coin_16: Area2D = $Levels/Level5/Node/healthCoin16
@onready var health_coin_17: Area2D = $Levels/Level5/Node/healthCoin17
@onready var health_coin_18: Area2D = $Levels/Level5/Node/healthCoin18

var health_points: int = 10
var points: int = 0
var checkpoint_reached: bool
var checkpoint_position: Vector2

func _ready() -> void:
	EventManager.on_player_dead.connect(_on_player_dead)
	EventManager.on_fruit_collected.connect(_on_fruit_collected)
	EventManager.on_checkpoint_reached.connect(_on_checkpoint_reached)
	EventManager.on_game_won.connect(_on_game_won)
	EventManager.on_player_damage.connect(_on_player_damage)
	EventManager.on_health_collected.connect(_on_health_collected)
	EventManager.end_game.connect(_end_game)
	health_points_label.text = str(health_points)
	points_label.text = str(points)
	
func get_respawn_pos() -> Vector2:
	if checkpoint_reached:
		return checkpoint_position
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
	SoundManager.play_player_mocking()
	player.player_dead()
	await get_tree().create_timer(0.5).timeout
	var tween := create_tween()
	tween.tween_property(player, "global_position", get_respawn_pos(), 0.5)
	tween.tween_callback(player.player_respawn)
	health_points = 10
	health_points_label.text = str(health_points)
	
func _on_health_collected() -> void:
	health_points += 1
	health_points_label.text = str(health_points)
	
func _on_fruit_collected() -> void:
	points += 1
	points_label.text = str(points)

func _on_checkpoint_reached(position) -> void:
	checkpoint_reached = true
	checkpoint_position = position
	
func _on_game_won() -> void:
	game_won_panel.show()

func _on_play_button_pressed() -> void:
	get_tree().reload_current_scene()
	SoundManager.play_music()

func _end_game() -> void:
	SoundManager.play_woo()
	node.visible = true
	end_checkpoint.monitoring = true
	health_coin.monitoring = true
	health_coin_2.monitoring = true
	health_coin_3.monitoring = true
	health_coin_4.monitoring = true
	health_coin_5.monitoring = true
	health_coin_6.monitoring = true
	health_coin_7.monitoring = true
	health_coin_8.monitoring = true
	health_coin_9.monitoring = true
	health_coin_10.monitoring = true
	health_coin_11.monitoring = true
	health_coin_12.monitoring = true
	health_coin_13.monitoring = true
	health_coin_14.monitoring = true
	health_coin_15.monitoring = true
	health_coin_16.monitoring = true
	health_coin_17.monitoring = true
	health_coin_18.monitoring = true
