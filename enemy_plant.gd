extends CharacterBody2D
class_name EnemyPlant

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_hole: Marker2D = $ShootingHole
@onready var shooting_direction: Marker2D = $ShootingDirection
@onready var timer: Timer = $Timer
@export var health: int = 5
@export var ball_damage = 2
@export var touch_damage = 1
@export var plant_bullet: PackedScene
@export var player: Node2D

var defeated := false
var top_jumped := false
var bottom_touched := false
var body_in_area := false
var hitted := false

func _ready() -> void:
	add_to_group("enemy")
	
func _on_top_area_body_entered(body: Node2D) -> void:
	if bottom_touched:
		return
	if body is Player:
		top_jumped = true
		body.velocity.y = -400
		hit_by_player(2)
		top_jumped = false


func _on_bottom_area_body_entered(body: Node2D) -> void:
	if defeated or top_jumped:
			return
	if body is Player:
		bottom_touched = true
		EventManager.on_player_damage.emit(touch_damage)
		await get_tree().create_timer(2).timeout
	bottom_touched = false
	
func shoot() -> void:
	var bullet = plant_bullet.instantiate()
	bullet.ball_damage = ball_damage
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shooting_hole.global_position
	var direction = (
		shooting_direction.global_position - shooting_hole.global_position
	).normalized()
	bullet.initialize(direction)
	anim_sprite.play("attack")


func _on_timer_timeout() -> void:
	shoot()

func hit_by_player(damage: int) -> void:
	if hitted:
		return
	hitted = true
	anim_sprite.play("hit")
	health -= damage
	await anim_sprite.animation_finished
	#await get_tree().create_timer(0.5).timeout
	if health <= 0:
		defeated = true
		queue_free()
	hitted = false
