extends CharacterBody2D
class_name EnemyChameleon

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@export var health: int = 6
@export var touch_damage = 1
@export var tongue_damage = 2
@export var player: Node2D
@export var body_in_area = false

var defeated := false
var top_jumped := false
var bottom_touched := false
var attacking := false
var hit_player  := false
var hitted := false

func _ready() -> void:
	add_to_group("enemy")	
	
func _process(delta: float) -> void:
	await get_tree().create_timer(1).timeout
	attack_player()
	
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
	
	
func attack_player() -> void:
	if attacking:
		return
	attacking = true
	hit_player = false
	anim_sprite.play("attack")
	await anim_sprite.animation_finished
	attacking = false
	
func _on_animated_sprite_2d_frame_changed() -> void:
	if anim_sprite == null:
		return
	if anim_sprite.animation != "attack":
		return
	if anim_sprite.frame == 6:
		check_tongue_hit()
	
func check_tongue_hit() -> void:
	if hit_player:
		return
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var body = ray_cast.get_collider()
		if body is Player:
			hit_player = true
			EventManager.on_player_damage.emit(tongue_damage)

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
