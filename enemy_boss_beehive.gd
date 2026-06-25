extends CharacterBody2D
class_name EnemyBossBehive

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_hole: Marker2D = $ShootingHole
@onready var timer_spawn: Timer = %TimerSpawn
@onready var timer_hittable: Timer = %TimerHittable
@onready var enemy_area: Area2D = $EnemyArea
@export var health: int = 30
@export var touch_damage = 3
@export var enemy_bee: PackedScene
@export var player: Node2D
@export var bee_paths: Array[CustomPathFollow]

var defeated := false
var top_jumped := false
var bottom_touched := false
var body_in_area := false
var hittable := false

func _ready():
	timer_spawn.timeout.connect(spawn_bees)
	timer_hittable.timeout.connect(change_state)	
	
	
func _on_bottom_area_body_entered(body: Node2D) -> void:
	if defeated or top_jumped:
			return
	if body is Player:
		bottom_touched = true
		EventManager.on_player_damage.emit(touch_damage)
		await get_tree().create_timer(2).timeout
	bottom_touched = false
	
func spawn_bees() -> void:
	if !body_in_area:
		return
	var path = get_free_path()
	if path == null:
		return
	var bee: EnemyBee = enemy_bee.instantiate()
	get_tree().current_scene.add_child(bee)
	bee.global_position = shooting_hole.global_position
	path.current_bee = bee
	path.can_move = false
	bee.set_path(path)
	
func change_state() -> void:
	if not hittable:
		anim_sprite.play("protected")
	if hittable:
		anim_sprite.play("idle")
	hittable = !hittable


func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body_in_area = true
		
func get_free_path() -> CustomPathFollow:
	var free_paths: Array[CustomPathFollow] = []
	for p in bee_paths:
		if p.is_free():
			free_paths.append(p)
	if free_paths.is_empty():
		return null
	return free_paths.pick_random()
