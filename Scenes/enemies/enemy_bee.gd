extends CharacterBody2D
class_name EnemyBee

@export var path: CustomPathFollow
@export var health: int = 5
@export var sting_damage = 2
@export var touch_damage = 1
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooting_hole: Marker2D = $ShootingHole
@export var bee_bullet: PackedScene
@export var player: PackedScene

var defeated := false
var top_jumped := false
var bottom_touched := false

func _process(delta: float) -> void:
	anim_sprite.flip_h = path.direction == 1
	

func _on_top_area_body_entered(body: Node2D) -> void:
	if bottom_touched:
		return
	if not body is Player:
		return
	top_jumped = true
	anim_sprite.play("hit")
	body.velocity.y = -400
	health -= 1
	await anim_sprite.animation_finished
	#await get_tree().create_timer(0.5).timeout
	if health <= 0:
		path.can_move = false
		defeated = true
		queue_free()
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

	var bullet = bee_bullet.instantiate()
	bullet.sting_damage = sting_damage
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = shooting_hole.global_position

	var direction = (
		body.global_position - shooting_hole.global_position
	).normalized()

	bullet.initialize(direction)
	
