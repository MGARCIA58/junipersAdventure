extends CharacterBody2D
class_name EnemyBee

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_hole: Marker2D = $ShootingHole
@onready var timer: Timer = $Timer
@export var path: CustomPathFollow
@export var health: int = 5
@export var sting_damage = 2
@export var touch_damage = 1
@export var bee_bullet: PackedScene
@export var player: Node2D
@export var fly_speed := 200.0
enum State {
	SPAWNING,
	PATROL
}

var state := State.SPAWNING
var defeated := false
var top_jumped := false
var bottom_touched := false
var body_in_area := false
var hitted := false

func _ready():
	add_to_group("enemy")
	timer.timeout.connect(shoot_at_player)
	
func _physics_process(delta):
	match state:
		State.SPAWNING:
			global_position = global_position.move_toward(path.global_position,fly_speed * delta)
			if global_position.distance_to(path.global_position) < 5:
				path.can_move = true
				state = State.PATROL
		State.PATROL:
			global_position = global_position.move_toward(path.global_position,300 * delta)
	
func set_path(new_path: CustomPathFollow):
	path = new_path
	
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


func _on_shooting_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if body_in_area: return
	body_in_area = true
	player = body
	timer.start()

func _on_shooting_area_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body_in_area = false
	timer.stop()
	

func shoot_at_player() -> void:
	if not body_in_area:
		return
	var bullet = bee_bullet.instantiate()
	bullet.sting_damage = sting_damage
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = shooting_hole.global_position

	var direction = (
		player.global_position - shooting_hole.global_position
	).normalized()

	bullet.initialize(direction)
	anim_sprite.play("attack")

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
