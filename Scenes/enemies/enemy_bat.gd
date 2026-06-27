extends CharacterBody2D
class_name EnemyBat

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@export var path: CustomPathFollow
@export var health: int = 2
@export var touch_damage = 2
@export var player: Node2D
@export var body_in_area = false

var defeated := false
var top_jumped := false
var bottom_touched := false
var attacking := false
var hitted := false

func _ready():
	add_to_group("enemy")
	timer.timeout.connect(attack_player)
	
func _process(delta: float) -> void:
	anim_sprite.flip_h = path.direction == 1
	

func _on_top_area_body_entered(body: Node2D) -> void:
	return #solo daño por bala
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
	


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not body is Player: return
	if body_in_area: return
	body_in_area = true
	player = body
	timer.start()

func _on_attack_area_body_exited(body: Node2D) -> void:
	if not body is Player: return
	body_in_area = false
	timer.stop()
	

func attack_player() -> void:
	if not body_in_area:
		return
	if attacking:
		return
	SoundManager.play_bat_attacking()
	attacking = true
	path.can_move = false
	var start_position = global_position
	var target_position = player.global_position
	var tween = create_tween()
	tween.tween_property(self,"global_position",target_position,0.4)
	tween.tween_interval(0.2)
	tween.tween_property(self,"global_position",start_position,0.4)
	await tween.finished
	path.can_move = true
	attacking = false
	timer.start()

func hit_by_player(damage: int) -> void:
	if hitted:
		return
	hitted = true
	anim_sprite.play("hit")
	health -= damage
	await get_tree().create_timer(0.5).timeout
	if health <= 0:
		defeated = true
		queue_free()
	hitted = false
	anim_sprite.play("fly")
