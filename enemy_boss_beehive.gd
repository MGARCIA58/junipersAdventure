extends CharacterBody2D
class_name EnemyBossBehive

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_hole: Marker2D = $ShootingHole
@onready var timer_spawn: Timer = %TimerSpawn
@onready var timer_hittable: Timer = %TimerHittable
@onready var enemy_area: Area2D = $EnemyArea
@export var health: int = 40
@export var touch_damage = 3
@export var enemy_bee: PackedScene
@export var player: Node2D
@export var bee_paths: Array[CustomPathFollow]

var defeated := false
var top_jumped := false
var bottom_touched := false
var body_in_area := false
var hittable := true
var current_state := BossState.IDLE
var can_play := false

enum BossState {
	IDLE,
	PROTECTED,
	HIT,
	DEAD
}

func _ready():
	add_to_group("enemy")
	timer_spawn.timeout.connect(spawn_bees)
	timer_hittable.timeout.connect(change_state)	
	
func set_state(new_state: BossState) -> void:
	if current_state == BossState.DEAD:
		return
	current_state = new_state
	if can_play:
		SoundManager.stop_panal()
	match current_state:
		BossState.IDLE:
			anim_sprite.play("idle")
		BossState.PROTECTED:
			anim_sprite.play("protected")
			if can_play:
				SoundManager.play_panal()
		BossState.HIT:
			anim_sprite.play("hit")
		BossState.DEAD:
			anim_sprite.play("defeated")
	
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
	bee.health = 2
	bee.global_position = shooting_hole.global_position
	path.current_bee = bee
	path.can_move = false
	bee.set_path(path)
	
func change_state() -> void:
	if current_state == BossState.DEAD:
		return
	hittable = !hittable
	if hittable:
		set_state(BossState.IDLE)
	else:
		set_state(BossState.PROTECTED)


func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body_in_area = true
		timer_spawn.start()
		
func get_free_path() -> CustomPathFollow:
	var free_paths: Array[CustomPathFollow] = []
	for p in bee_paths:
		if p.is_free():
			free_paths.append(p)
	if free_paths.is_empty():
		return null
	return free_paths.pick_random()
	
func hit_by_player(damage: int) -> void:
	if current_state == BossState.DEAD:
		return
	if not hittable:
		return
	set_state(BossState.HIT)
	health -= damage
	await anim_sprite.animation_finished
	if health <= 0:
		defeated = true
		timer_spawn.stop()
		timer_hittable.stop()
		set_state(BossState.DEAD)
		anim_sprite.rotation_degrees = 180
		EventManager.end_game.emit()
		await anim_sprite.animation_finished
		return
	if hittable:
		set_state(BossState.IDLE)
	else:
		set_state(BossState.PROTECTED)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	can_play = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	can_play = false
